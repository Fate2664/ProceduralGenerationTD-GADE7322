using UnityEngine;

namespace Systems
{
    public class EntityFactory<T> : IEntityFactory<T> where T : Entity
    {
        private EntityData[] data;

        public EntityFactory(EntityData[] data)
        {
            this.data = data;
        }

        public T Create(Transform spawnPoint)
        {
            EntityData selected = data[Random.Range(0, data.Length)];
            return Create(selected, spawnPoint);
        }
        
        public T Create(EntityData selected, Transform spawnPoint)
        {
            GameObject instance = GameObject.Instantiate(selected.prefab, spawnPoint.position, spawnPoint.rotation);
            return instance.GetComponent<T>();
        }
    }
}