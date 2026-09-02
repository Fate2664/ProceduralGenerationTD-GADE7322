using UnityEngine;

namespace Defenses.DefenseCharacters
{
    public class DefenseCharacterAttackState : DefenseCharacterBaseState
    {
        public DefenseCharacterAttackState(DefenseCharacterBase characterBase, Animator animator) : base(characterBase, animator)
        {
        }

        public override void OnEnter()
        {
            animator.CrossFade(attackHash, crossFadeDuration);
        }

        public override void Update()
        {
            characterBase.Attack();
        }
    }
}