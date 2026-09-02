using System;
using DG.Tweening;
using StateMachine;
using Systems;
using UnityEngine;

namespace Defenses.DefenseCharacters
{
    public class DefenseCharacterBase : Entity
    {
        [SerializeField] private float timeBetweenAttacks = 1f;
        [SerializeField] private float turnSpeed = 360.0f;
                
        protected StateMachine.StateMachine stateMachine;
        protected Animator animator;
        protected EnemyDetector enemyDetector;
        
        protected IState idleState;
        protected IState attackState;

        protected CountDownTimer attackTimer;
        private Transform pathTarget;

        private void Awake()
        {
            animator = GetComponentInChildren<Animator>();
            enemyDetector = GetComponent<EnemyDetector>();

            stateMachine = new StateMachine.StateMachine();
            attackTimer =  new CountDownTimer(timeBetweenAttacks);
        }
        
        protected void At(IState from, IState to, IPredicate condition) => stateMachine.AddTransition(from, to, condition);
        protected void Any(IState to, IPredicate condition) => stateMachine.AddAnyTransition(to, condition);

        private void Update()
        {
            if (stateMachine.CurrentState == null) return;
            
            enemyDetector.TickDetection(Time.deltaTime);
            UpdateFacing(Time.deltaTime);
            
            stateMachine.Update();
            attackTimer.Tick(Time.deltaTime);
        }

        private void FixedUpdate()
        {
            if (stateMachine.CurrentState == null) return;
            
            stateMachine.FixedUpdate();
        }

        public virtual void Initialize(Transform nearestPath = null)
        {
            pathTarget = nearestPath;

            if (pathTarget != null)
            {
                Vector3 direction = pathTarget.position - transform.position;
                direction.y = 0f;

                if (direction.sqrMagnitude <= Mathf.Epsilon)
                    return;
                
                transform.rotation = Quaternion.LookRotation(direction, Vector3.up);
            }
        }

        private void UpdateFacing(float deltaTime)
        {
            //Enemies take priority over path
            Transform facingTarget = enemyDetector.Enemy != null ? enemyDetector.Enemy : pathTarget;

            if (facingTarget == null) return;
            
            Vector3 direction = facingTarget.position - transform.position;
            direction.y = 0f;
            
            if (direction.sqrMagnitude <= Mathf.Epsilon)
                return;
            
            Quaternion targetRotation = Quaternion.LookRotation(direction.normalized, Vector3.up);
            transform.rotation = Quaternion.RotateTowards(transform.rotation, targetRotation, turnSpeed * deltaTime);
        }

        public virtual void Attack()
        {
            if (attackTimer.IsRunning) return;

            PerformAttack();
            attackTimer.Start();
        }

        protected virtual void PerformAttack() {}
    }
}