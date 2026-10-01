using System;
using StateMachine;
using UnityEngine;

namespace Defenses.DefenseCharacters.MeleeAnt
{
    public class MeleeDefenseCharacter : DefenseCharacterBase
    {
        [SerializeField] private int attackDamage = 1;
        [SerializeField] private float meleeRange = 2f;

        private Transform target;

        public override void Initialize(Transform pathTarget = null)
        {
            base.Initialize(pathTarget);

            idleState = new DefenseCharacterIdleState(this, animator);
            attackState = new DefenseCharacterAttackState(this, animator);
            
            At(idleState, attackState, new FuncPredicate(() => enemyDetector.CanSeeEnemy()));
            At(attackState, idleState, new FuncPredicate(() => !enemyDetector.CanSeeEnemy()));
            
            stateMachine.SetState(idleState);
        }

        protected override void PerformAttack()
        {
            target = enemyDetector.Enemy;
        }

        public void MeleeHit()
        {
            Transform hitTarget = target;
            target = null;
            
            if (IsDead || stateMachine.CurrentState != attackState || hitTarget == null)
                return;
            
            if (!IsInMeleeRange(hitTarget))
                return;
            
            if (hitTarget.TryGetComponent<IDamageable>(out IDamageable damageable))
            {
                damageable.TakeDamage(attackDamage);
            }
        }

        private bool IsInMeleeRange(Transform candidate)
        {
            Vector3 distance = candidate.position - transform.position;
            return distance.sqrMagnitude <= meleeRange * meleeRange;
        }
    }
}