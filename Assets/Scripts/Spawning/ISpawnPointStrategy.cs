using UnityEngine;

namespace Spawning
{
    public interface ISpawnPointStrategy
    {
        Transform NextSpawnPoint();
    }
}