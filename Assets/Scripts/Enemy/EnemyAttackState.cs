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
        
        public EnemyAttackState(EnemyBase enemyBase, Animator animator, NavMeshAgent agent) : base(enemyBase, animator)
        {
            this.agent = agent;
        }

        public override void OnEnter()
        {
            agent.isStopped = true;
            agent.updateRotation = false;
            animator.CrossFade(attackHash, crossFadeDuration);
        }

        public override void OnExit()
        {
            agent.isStopped = false;
            agent.updateRotation = true;
        }

        public override void Update()
        {
            RotateTowardsTarget();
            EnemyBase.Attack();            
        }

        private void RotateTowardsTarget()
        {
            Transform target = EnemyBase.CurrentTarget;

            if (target == null)
                return;

            Vector3 direction = target.position - EnemyBase.transform.position;
            //only rotate horizontally
            direction.y = 0;

            if (direction.sqrMagnitude <= Mathf.Epsilon)
                return;
            
            Quaternion targetRotation = Quaternion.LookRotation(direction.normalized, Vector3.up);
            EnemyBase.transform.rotation = Quaternion.RotateTowards(EnemyBase.transform.rotation, targetRotation, agent.angularSpeed * Time.deltaTime);
        }
    }
}