using StateMachine;
using UnityEngine;

namespace Defenses.DefenseCharacters
{
    public class DefenseCharacterBaseState : IState
    {
        protected readonly DefenseCharacterBase characterBase;
        protected readonly Animator animator;
        
        protected static readonly int idleHash = Animator.StringToHash("Idle");
        protected static readonly int attackHash = Animator.StringToHash("Attack");

        protected const float crossFadeDuration = 0.2f;

        protected DefenseCharacterBaseState(DefenseCharacterBase characterBase, Animator animator)
        {
            this.characterBase = characterBase;
            this.animator = animator;
        }
        
        public virtual void OnEnter() { }
        public virtual void Update() { }
        public virtual void FixedUpdate() { }
        public virtual void OnExit() { }
    }
}