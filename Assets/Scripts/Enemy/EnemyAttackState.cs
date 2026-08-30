using System;
using StateMachine;
using UnityEngine;
using UnityEngine.AI;

namespace Enemy
{
    public class EnemyAttackState : EnemyBaseState
    {
        private readonly NavMeshAgent agent;
        private readonly Transform tower;
        
        public EnemyAttackState(EnemyBase enemyBase, Animator animator, NavMeshAgent agent, Transform tower) : base(enemyBase, animator)
        {
            this.agent = agent;
            this.tower = tower;
        }

        public override void OnEnter()
        {
            agent.isStopped = true;
            animator.CrossFade(attackHash, crossFadeDuration);
        }

        public override void Update()
        {
            EnemyBase.Attack();            
        }
    }
}