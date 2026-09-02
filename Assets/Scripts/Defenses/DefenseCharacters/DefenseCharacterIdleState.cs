using UnityEngine;

namespace Defenses.DefenseCharacters
{
    public class DefenseCharacterIdleState : DefenseCharacterBaseState
    {
        public DefenseCharacterIdleState(DefenseCharacterBase characterBase, Animator animator) : base(characterBase, animator)
        {
        }

        public override void OnEnter()
        {
            animator.CrossFade(idleHash, crossFadeDuration);
        }

        public override void Update()
        {
            
        }
    }
}