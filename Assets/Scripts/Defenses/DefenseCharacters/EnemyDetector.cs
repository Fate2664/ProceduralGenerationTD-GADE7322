using System;
using Systems;
using UnityEngine;

namespace Defenses.DefenseCharacters
{
    public class EnemyDetector : MonoBehaviour
    {
        [SerializeField] private float detectionAngle = 360.0f; //Sphere around defense
        [SerializeField] private float detectionRadius = 10.0f; //Distance from defense
        [SerializeField] private float innerDetectionRadius = 5.0f; //Small detection circle around defense
        [SerializeField] private float detectionCooldown = 1f; //Time between detections
        [SerializeField] private float detectionRange = 2f;
        
        public Transform Enemy { get; private set; }
        private CountDownTimer detectionTimer;
        
        IDetectionStrategy detectionStrategy;

        private void Awake()
        {
            detectionTimer = new CountDownTimer(detectionCooldown);
            detectionStrategy = new ConeDetectionStrategy(detectionAngle, detectionRadius, innerDetectionRadius);
        }

        public void TickDetection(float deltaTime)
        {
            detectionTimer.Tick(deltaTime);

            if (detectionTimer.IsRunning)
                return;

            FindNearestEnemy();
            detectionTimer.Start();
        }

        private void FindNearestEnemy()
        {
            Enemy = null;

            if (detectionStrategy == null) return;

            float nearestDistanceSquared = float.PositiveInfinity;

            foreach (var enemy in GameObject.FindGameObjectsWithTag("Enemy"))
            {
                if (!detectionStrategy.Execute(enemy.transform, transform))
                    continue;
                
                Vector3 offset = enemy.transform.position - transform.position;
                offset.y = 0f;
                
                if (offset.sqrMagnitude >= nearestDistanceSquared)
                    continue;
                
                nearestDistanceSquared = offset.sqrMagnitude;
                Enemy = enemy.transform;
            }
        }

        public bool CanSeeEnemy() => Enemy != null;
        
        public void SetDetectionStrategy(IDetectionStrategy strategy) =>  detectionStrategy = strategy;
    }
}