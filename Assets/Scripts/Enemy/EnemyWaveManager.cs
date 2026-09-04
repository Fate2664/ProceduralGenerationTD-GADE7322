using System;
using System.Collections.Generic;
using Nova;
using PCG;
using Systems;
using UnityEngine;

namespace Enemy
{
    public class EnemyWaveManager : EntitySpawnManager
    {
        [Header("References")] 
        [SerializeField] private EnemyData[] enemyData;
        [SerializeField] private WorldGenerator worldGenerator;
        [SerializeField] private TextBlock waveText;

        [Header("Wave Settings")] 
        [SerializeField] private float spawnRate = 1f;
        [SerializeField] private int enemiesPerWave = 4;
        [SerializeField] private float timeBetweenWaves = 5f;
        [SerializeField] private int extraEnemiesPerWave = 2;

        private EntitySpawner<EnemyBase> spawner;
        private CountDownTimer nextWaveTimer;
        private CountDownTimer spawnTimer;
        private readonly HashSet<EnemyBase> activeEnemies = new();

        private int counter;
        private int currentWave;
        private int currentWaveSize;

        private void Start()
        {
            InitializeSpawnPoints(worldGenerator.SpawnPoints);

            spawner = new EntitySpawner<EnemyBase>(new EntityFactory<EnemyBase>(enemyData), spawnPointStrategy);

            spawnTimer = new CountDownTimer(spawnRate);
            spawnTimer.OnTimerStop += HandleSpawnTimerStopped;
            
            waveText.Text = currentWave.ToString();
            nextWaveTimer = new CountDownTimer(timeBetweenWaves);
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
            EnemyBase enemy = spawner.Spawn(out Transform spawnPoint);
            var path = worldGenerator.GetPathForSpawnPoint(spawnPoint);

            if (path == null || !enemy.PlaceOnNavMesh(spawnPoint.position))
            {
                Destroy(enemy.gameObject);
                return;
            }
            
            enemy.Initialize(worldGenerator.Tower, path);
            activeEnemies.Add(enemy);
            enemy.Died += HandleEnemyDied;
        }

        private void BeginWave()
        {
            currentWave++;
            counter = 0;
            
            waveText.Text = currentWave.ToString();
            currentWaveSize = enemiesPerWave + (currentWave - 1) * extraEnemiesPerWave;
            
            Debug.Log($"Starting wave {currentWave} with {currentWaveSize} enemies");
            
            spawnTimer.Start();
        }

        private void HandleSpawnTimerStopped()
        {
            if (counter >= currentWaveSize)
                return;

            Spawn();
            counter++;

            if (counter < currentWaveSize)
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
            bool finishedSpawning = counter >= currentWaveSize;

            if (!finishedSpawning || activeEnemies.Count > 0)
                return;
            
            Debug.Log($"Wave {currentWave} completed");
            nextWaveTimer.Start();
        }
    }
}