using System;
using System.Collections.Generic;
using StateMachine;
using Systems;
using UnityEngine;
using UnityEngine.AI;

namespace Enemy
{
    public class EnemyBase : Entity
    {
        [SerializeField] private float timeBetweenAttacks = 1f;
        [SerializeField] private float moveSpeed = 1f;
        
        protected StateMachine.StateMachine stateMachine;
        protected NavMeshAgent agent;
        protected Animator animator;
        protected Transform target;

        protected IState walkState;
        protected IState attackState;
        
        protected CountDownTimer attackTimer;

        protected virtual void Awake()
        {
            agent = GetComponent<NavMeshAgent>();
            animator = GetComponent<Animator>();

            stateMachine = new StateMachine.StateMachine();
            attackTimer = new CountDownTimer(timeBetweenAttacks);
            agent.speed = moveSpeed;
        }

        protected void At(IState from, IState to, IPredicate condition) => stateMachine.AddTransition(from, to, condition);
        protected void Any(IState to, IPredicate condition) => stateMachine.AddAnyTransition(to, condition);

        private void Update()
        {
            if (stateMachine.CurrentState == null) return;
            
            stateMachine.Update();
            attackTimer.Tick(Time.deltaTime);
        }

        private void FixedUpdate()
        {
            if (stateMachine.CurrentState == null) return;
            
            stateMachine.FixedUpdate();
        }

        public virtual void Initialize(Transform target, List<GameObject> path)
        {
            this.target = target;
        }

        public bool PlaceOnNavMesh(Vector3 position, float maxDistance = 3f)
        {
            int areaMask = agent.areaMask;
            if (!NavMesh.SamplePosition(position, out NavMeshHit hit, maxDistance, areaMask))
                return false;
            
            agent.enabled = false;
            transform.position = hit.position;
            agent.enabled = true;

            return agent.isOnNavMesh;
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
