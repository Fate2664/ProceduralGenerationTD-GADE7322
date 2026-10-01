using System;
using System.Collections.Generic;
using Defenses;
using Defenses.DefenseCharacters;
using Nova;
using PCG;
using Spawning;
using Systems;
using UnityEngine;

namespace Enemy
{
    public class EnemyWaveManager : EntitySpawnManager
    {
        [Header("References")] 
        [SerializeField] private EnemyData[] enemyData;
        [SerializeField] private DefensePlacementManager defensePlacementManager;

        [SerializeField] private WorldGenerator worldGenerator;
        [SerializeField] private TextBlock waveText;

        [Header("Wave Budget")] [SerializeField]
        private int startingBudget = 4;

        [SerializeField] private int budgetIncreasePerWave = 2;
        [SerializeField] private int maxWaveBudget = 100;
        [SerializeField] private int maxEnemiesPerWave = 100;

        [Header("Performance Adaption")] [SerializeField]
        private float maxMultiplierChangePerWave = 0.1f;

        [Header("Timing")] [SerializeField] private float spawnRate = 1f;
        [SerializeField] private float timeBetweenWaves = 5f;

        [Header("Generation")] [SerializeField]
        private int waveSeed = 12345;

        private readonly BudgetWavePlanner planner = new();
        private readonly HashSet<EnemyBase> activeEnemies = new();
        private readonly WavePerformanceTracker performanceTracker = new();

        private EntityFactory<EnemyBase> factory;
        private CountDownTimer nextWaveTimer;
        private CountDownTimer spawnTimer;

        private WavePlan currentPlan;
        private Tower tower;
        private float budgetMultiplier = 1f;
        private int currentWave;
        private int nextInstruction;
        private bool waveCompleted;

        public WavePerformance PreviousWave => performanceTracker.PreviousWave;

        private void Start()
        {
            tower = worldGenerator.Tower.GetComponent<Tower>();
            factory = new EntityFactory<EnemyBase>(enemyData);

            spawnTimer = new CountDownTimer(spawnRate);
            nextWaveTimer = new CountDownTimer(timeBetweenWaves);

            spawnTimer.OnTimerStop += HandleSpawnTimerStopped;
            nextWaveTimer.OnTimerStop += BeginWave;
            defensePlacementManager.DefensePlaced += HandleDefensePlaced;
            tower.Damaged += HandleTowerDamaged;

            BeginWave();
        }

        void Update()
        {
            if (tower == null)
            {
                StopSpawning();
                return;
            }

            spawnTimer.Tick(Time.deltaTime);
            nextWaveTimer.Tick(Time.deltaTime);

            FinishWave();
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
                StopSpawning();
                return;
            }

            enemy.Initialize(worldGenerator.Tower, instruction.PathProfile.Path);
            RegisterEnemy(enemy);

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
            int baseBudget = (int)System.Math.Min(requestedBudget, maxWaveBudget);
            int budget = Mathf.Clamp(Mathf.RoundToInt(baseBudget * budgetMultiplier), 1, maxWaveBudget);
            int seed = unchecked(waveSeed + currentWave * 397);

            currentPlan = planner.CreatePlan(currentWave, budget, enemyData, paths, new System.Random(seed),
                maxEnemiesPerWave);

            performanceTracker.BeginWave(currentWave, tower.MaxHealth);

            foreach (var tile in worldGenerator.Grid)
            {
                if (tile.Occupant == null)
                    continue;

                if (tile.Occupant.TryGetComponent(out DefenseCharacterBase defender))
                    performanceTracker.RegisterDefender(defender);
            }

            waveText.Text = currentWave.ToString();

            Debug.Log(
                $"Wave {currentWave}: base budget {baseBudget}, " +
                $"multiplier {budgetMultiplier:F2}, " +
                $"adjusted budget {budget}, " +
                $"{currentPlan.Instructions.Count} planned enemies.");

            spawnTimer.Start();
        }

        public void RegisterEnemy(EnemyBase enemy)
        {
            if (!activeEnemies.Add(enemy) || !performanceTracker.IsRecording)
                return;

            enemy.Died += HandleEnemyDied;
            performanceTracker.RegisterEnemy(enemy);

            if (enemy is SwarmerEnemy.SwarmerEnemy swarmer)
                swarmer.SetWaveManager(this);
        }

        #region Handle Methods

        private void HandleSpawnTimerStopped()
        {
            Spawn();

            if (!enabled)
                return;

            if (nextInstruction < currentPlan.Instructions.Count)
                spawnTimer.Start();
        }

        private void HandleEnemyDied(EnemyBase enemy)
        {
            enemy.Died -= HandleEnemyDied;
            activeEnemies.Remove(enemy);
        }

        private void HandleTowerDamaged(float actualDamge)
        {
            performanceTracker.RecordTowerDamage(actualDamge);
        }

        private void HandleDefensePlaced(DefenseCharacterBase defender)
        {
            performanceTracker.RegisterDefender(defender);
        }

        #endregion

        private void FinishWave()
        {
            if (waveCompleted || nextInstruction < currentPlan.Instructions.Count || activeEnemies.Count > 0 ||
                performanceTracker.HasPendingProjectiles)
                return;

            waveCompleted = true;

            WavePerformance result = performanceTracker.FinishWave();
            budgetMultiplier = CalculateNextBudgetMultiplier(result);

            Debug.Log(
                $"Wave {result.WaveNumber} completed. " +
                $"Tower damage: {result.TowerDamageTaken:F0}; " +
                $"defenders killed: {result.DefendersKilled}/" +
                $"{result.DefendersTracked}; " +
                $"tower arrivals: {result.EnemiesReachedTower}/" +
                $"{result.EnemiesSpawned}; " +
                $"next budget multiplier: {budgetMultiplier:F2}.");

            nextWaveTimer.Start();
        }

        private float CalculateNextBudgetMultiplier(WavePerformance result)
        {
            // Damage Pressue:
            float damagePressure =
                Mathf.Clamp01(result.TowerDamageTaken / Mathf.Max(1f, result.TowerMaxHealth * 0.20f));
            //Defenders Killed Pressue:
            float defenderPressure = result.DefendersTracked > 0
                ? result.DefendersKilled / (float)result.DefendersTracked
                : 0f;
            //Enemies Arrived At Tower Pressure:
            float arrivalPressure = result.EnemiesSpawned > 0
                ? result.EnemiesReachedTower / (float)result.EnemiesSpawned
                : 0f;

            // Combine into total pressure
            float totalPressure = 0.60f * damagePressure + 0.25f * defenderPressure + 0.15f * arrivalPressure;

            // Normal multiplier is 0.25
            float desiredMultiplier = Mathf.Clamp(1f + (0.25f - totalPressure) * 0.60f, 0.85f, 1.15f);

            float nextMultiplier = Mathf.MoveTowards(budgetMultiplier, desiredMultiplier, maxMultiplierChangePerWave);

            return Mathf.Clamp(nextMultiplier, 0.85f, 1.15f);
        }

        private void StopSpawning()
        {
            spawnTimer?.Pause();
            nextWaveTimer?.Pause();

            performanceTracker.CancelWave();
            enabled = false;
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