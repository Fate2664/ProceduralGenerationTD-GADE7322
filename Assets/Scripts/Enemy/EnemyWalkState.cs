using UnityEngine;
using UnityEngine.AI;

namespace Enemy
{
    public class EnemyWalkState : EnemyBaseState
    {
        private readonly NavMeshAgent agent;
        private readonly Transform tower;
        
        public EnemyWalkState(EnemyBase enemyBase, Animator animator, NavMeshAgent agent, Transform tower) : base(enemyBase, animator)
        {
            this.agent = agent;
            this.tower = tower;
        }

        public override void OnEnter()
        {
            animator.CrossFade(walkHash, crossFadeDuration);
            agent.SetDestination(tower.position);
        }
        
    }
}