using StateMachine;
using UnityEngine;
using UnityEngine.AI;

namespace Enemy
{
    public class CommonEnemy : EnemyBase
    {
        [SerializeField] private int attackDamage;
        
        private void Start()
        {
            if (target == null)
                return;
            
            walkState = new EnemyWalkState(this, animator, agent, target);
            attackState = new EnemyAttackState(this, animator, agent, target);
            
            At(walkState, attackState, new FuncPredicate(() => HasReachedTower()));  
            
            stateMachine.SetState(walkState);
        }

        protected override void PerformAttack()
        {
            //Attack tower if it is close enough
            if (target.TryGetComponent<IDamageable>(out var damageable))
                damageable.TakeDamage(attackDamage);
        }

        public bool HasReachedTower()
        {
            return !agent.pathPending && agent.hasPath && agent.pathStatus == NavMeshPathStatus.PathComplete && agent.remainingDistance <= agent.stoppingDistance;
        }
    }
}