using StateMachine;
using UnityEngine;

namespace Enemy
{
    public abstract class EnemyBaseState : IState
    {
        protected readonly EnemyBase EnemyBase;
        protected readonly Animator animator;
        
        //Get animation hashes
        protected static readonly int walkHash = Animator.StringToHash("Walk");
        protected static readonly int attackHash = Animator.StringToHash("Attack");
        
        protected const float crossFadeDuration = 0.2f;

        protected EnemyBaseState(EnemyBase enemyBase, Animator animator)
        {
            EnemyBase = enemyBase;
            this.animator = animator;
        }

        public virtual void OnEnter() {}
        public virtual void Update() { }
        public virtual void FixedUpdate() { }
        public virtual void OnExit() { }
    }
}