using System;
using Spawning;
using UnityEngine;

namespace Systems
{
    public class EntitySpawner<T> where T : Entity
    {
        private IEntityFactory<T> factory;
        private ISpawnPointStrategy spawnPointStrategy;

        public EntitySpawner(IEntityFactory<T> entityFactory, ISpawnPointStrategy spawnPointStrategy)
        {
            this.factory = entityFactory;
            this.spawnPointStrategy = spawnPointStrategy;
        }

        public T Spawn(out Transform spawnPoint)
        {
            spawnPoint = spawnPointStrategy.NextSpawnPoint();
            return factory.Create(spawnPoint);
        }
    }
}

