using System;
using PCG;
using Systems;
using UnityEngine;

namespace Enemy
{
    public class EnemySpawnManager : EntitySpawnManager
    {
        [SerializeField] private EnemyData[] enemyData;
        [SerializeField] private WorldGenerator worldGenerator;
        [SerializeField] private float spawnRate = 1f;
        [SerializeField] private int enemiesPerWave = 4;

        private EntitySpawner<EnemyBase> spawner;
        private CountDownTimer spawnTimer;
        private int counter;

        private void Start()
        {
            InitializeSpawnPoints(worldGenerator.SpawnPoints);

            spawner = new EntitySpawner<EnemyBase>(new EntityFactory<EnemyBase>(enemyData), spawnPointStrategy);

            spawnTimer = new CountDownTimer(spawnRate);
            spawnTimer.OnTimerStop += HandleSpawnTimerStopped;
            spawnTimer.Start();
        }

        void Update() => spawnTimer.Tick(Time.deltaTime);

        private void HandleSpawnTimerStopped()
        {
            if (counter >= enemiesPerWave)
                return;

            Spawn();
            counter++;

            if (counter < enemiesPerWave)
                spawnTimer.Start();
        }

        public override void Spawn()
        {
            EnemyBase enemy = spawner.Spawn(out Transform spawnPoint);
            if (enemy.PlaceOnNavMesh(spawnPoint.position))
            {
                enemy.Initialize(worldGenerator.Tower);
            }
        }
    }
}