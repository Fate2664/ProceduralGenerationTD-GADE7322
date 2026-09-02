using StateMachine;
using UnityEngine;

namespace Defenses.DefenseCharacters
{
    public class SpearDefenseCharacter : DefenseCharacterBase
    {
        [SerializeField] private int attackDamage;

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
            
        }
    }
}