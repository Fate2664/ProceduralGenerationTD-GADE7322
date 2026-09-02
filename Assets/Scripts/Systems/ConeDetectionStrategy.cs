using UnityEngine;

namespace Systems
{
    public class ConeDetectionStrategy : IDetectionStrategy
    {
        private readonly float detectionAngle;
        private readonly float detectionRadius;
        private readonly float innerDetectionRadius;

        public ConeDetectionStrategy(float detectionAngle, float detectionRadius, float innerDetectionRadius)
        {
            this.detectionAngle = detectionAngle;
            this.detectionRadius = detectionRadius;
            this.innerDetectionRadius = innerDetectionRadius;
        }
        
        public bool Execute(Transform enemy, Transform detector)
        {
            var directionToEnemy = enemy.position - detector.position;
            directionToEnemy.y = 0f;

            float distanceSquared = directionToEnemy.sqrMagnitude;

            if (distanceSquared <= innerDetectionRadius * innerDetectionRadius) return true;
            if (distanceSquared > detectionRadius * detectionRadius) return false;
            if (detectionAngle >= 360f) return true;

            float angleToEnemy = Vector3.Angle(directionToEnemy, detector.forward);
            return angleToEnemy <= detectionAngle * 0.5f;
        }
    }
}