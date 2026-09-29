using System;
using System.Collections.Generic;
using Nova;
using PCG;
using Spawning;
using Systems;
using UnityEngine;

namespace Enemy
{
    public class EnemyWaveManager : EntitySpawnManager
    {
        [Header("References")] [SerializeField]
        private EnemyData[] enemyData;

        [SerializeField] private WorldGenerator worldGenerator;
        [SerializeField] private TextBlock waveText;

        [Header("Wave Budget")] [SerializeField]
        private int startingBudget = 4;

        [SerializeField] private int budgetIncreasePerWave = 2;
        [SerializeField] private int maxWaveBudget = 100;
        [SerializeField] private int maxEnemiesPerWave = 100;

        [Header("Timing")] [SerializeField] private float spawnRate = 1f;
        [SerializeField] private float timeBetweenWaves = 5f;

        [Header("Generation")] [SerializeField]
        private int waveSeed = 12345;

        private readonly BudgetWavePlanner planner = new();
        private readonly HashSet<EnemyBase> activeEnemies = new();

        private EntityFactory<EnemyBase> factory;
        private CountDownTimer nextWaveTimer;
        private CountDownTimer spawnTimer;

        private WavePlan currentPlan;
        private int currentWave;
        private int nextInstruction;
        private bool waveCompleted;

        private void Start()
        {
            factory = new EntityFactory<EnemyBase>(enemyData);

            spawnTimer = new CountDownTimer(spawnRate);
            nextWaveTimer = new CountDownTimer(timeBetweenWaves);

            spawnTimer.OnTimerStop += HandleSpawnTimerStopped;
            nextWaveTimer.OnTimerStop += BeginWave;

            BeginWave();
        }

        void Update()
        {
            spawnTimer.Tick(Time.deltaTime);
            nextWaveTimer.Tick(Time.deltaTime);
        }

        public override void Spawn()
        {
            if (waveCompleted || nextInstruction >= currentPlan.Instructions.Count)
                return;

            SpawnInstruction instruction = currentPlan.Instructions[nextInstruction];
            EnemyBase enemy = factory.Create(instruction.Enemy, instruction.PathProfile.SpawnPoint);
            enemy.ConfigureForSpawn(instruction.Enemy);

            if (!enemy.PlaceOnNavMesh(instruction.PathProfile.SpawnPoint.position))
            {
                Destroy(enemy.gameObject);
                return;
            }

            enemy.Initialize(worldGenerator.Tower, instruction.PathProfile.Path);
            activeEnemies.Add(enemy);
            enemy.Died += HandleEnemyDied;

            nextInstruction++;
        }

        private void BeginWave()
        {
            currentWave++;
            nextInstruction = 0;
            waveCompleted = false;

            List<PathProfile> paths = PathAnalyzer.BuildProfiles(worldGenerator);
            long requestedBudget = Mathf.Max(1, startingBudget) +
                                   (long)(currentWave - 1) * Mathf.Max(0, budgetIncreasePerWave);
            int budget = (int)System.Math.Min(requestedBudget, Mathf.Max(1, maxWaveBudget));
            int seed = unchecked(waveSeed + currentWave * 397);

            currentPlan = planner.CreatePlan(currentWave, budget, enemyData, paths, new System.Random(seed),
                maxEnemiesPerWave);

            waveText.Text = currentWave.ToString();

            Debug.Log($"Wave {currentWave}: " + $"{currentPlan.Instructions.Count} enemies, " +
                      $"{currentPlan.SpentBudget}/{currentPlan.Budget} " + "threat points spent.");

            foreach (PathProfile path in paths)
            {
                Debug.Log(
                    $"Route {path.Id}: " +
                    $"length {path.Length:F1}, " +
                    $"adjacent defenses {path.AdjacentDefenseCount}, " +
                    $"adjacent coverage " +
                    $"{path.AdjacentDefenseRatio:P0}");
            }

            spawnTimer.Start();
        }

        private void HandleSpawnTimerStopped()
        {
            Spawn();

            if (!enabled)
                return;

            if (nextInstruction < currentPlan.Instructions.Count)
                spawnTimer.Start();
            else
                FinishWave();
        }

        private void HandleEnemyDied(EnemyBase enemy)
        {
            enemy.Died -= HandleEnemyDied;
            activeEnemies.Remove(enemy);

            FinishWave();
        }

        private void FinishWave()
        {
            if (waveCompleted || nextInstruction < currentPlan.Instructions.Count || activeEnemies.Count > 0)
                return;

            waveCompleted = true;
            Debug.Log($"Wave {currentWave} completed");

            nextWaveTimer.Start();
        }

        private void OnDestroy()
        {
            spawnTimer.OnTimerStop -= HandleSpawnTimerStopped;
            nextWaveTimer.OnTimerStop -= BeginWave;

            foreach (EnemyBase enemy in activeEnemies)
            {
                if (enemy != null)
                    enemy.Died -= HandleEnemyDied;
            }
        }
    }
}