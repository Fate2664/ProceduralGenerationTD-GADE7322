using System.Collections.Generic;
using Nova;
using StateMachine;
using UnityEngine;

namespace Enemy
{
    public class CommonEnemy : EnemyBase
    {
        private EnemyWalkState enemyWalkState;
        
        public override void Initialize(Transform target, List<GameObject> path)
        {
            base.Initialize(target, path);
            if (target == null || path == null || path.Count < 2)
                return;
            
            enemyWalkState = new EnemyWalkState(this, animator, agent, path);
            walkState = enemyWalkState;
            attackState = new EnemyAttackState(this, animator, agent, target);
            
            At(walkState, attackState, new FuncPredicate(() => enemyWalkState.HasFinishedPath));  
            
            stateMachine.SetState(walkState);
        }

        protected override void PerformAttack()
        {
            if (target == null) 
                return;
            
            //Attack tower if it is close enough
            if (target.TryGetComponent<IDamageable>(out var damageable))
                damageable.TakeDamage(EnemyData.AttackDamage);
        }

    }
}