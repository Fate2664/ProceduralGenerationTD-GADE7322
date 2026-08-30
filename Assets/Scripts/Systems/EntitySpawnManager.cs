using Spawning;
using UnityEngine;

namespace Systems
{
    public abstract class EntitySpawnManager : MonoBehaviour
    {
        protected enum SpawnPointStrategyType
        {
            Linear,
            Random
        }

        [SerializeField] protected SpawnPointStrategyType spawnPointStrategyType = SpawnPointStrategyType.Linear;
        
        protected Transform[] spawnPoints;
        protected ISpawnPointStrategy spawnPointStrategy;

        protected void InitializeSpawnPoints(Transform[] points)
        {
            spawnPoints = points;
            
            spawnPointStrategy = spawnPointStrategyType switch
            {
                SpawnPointStrategyType.Linear => new LinearSpawnPointStrategy(spawnPoints),
                SpawnPointStrategyType.Random => new RandomSpawnPointStrategy(spawnPoints),
                _ => spawnPointStrategy
            };
        }

        public abstract void Spawn();
    }
}