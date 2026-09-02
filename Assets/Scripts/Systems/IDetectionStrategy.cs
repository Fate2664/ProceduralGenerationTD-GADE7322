using UnityEngine;

namespace Systems
{
    public interface IDetectionStrategy
    {
        bool Execute(Transform enemy, Transform detector);
    }
}