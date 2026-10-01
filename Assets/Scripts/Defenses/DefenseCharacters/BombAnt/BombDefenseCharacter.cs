using StateMachine;
using UnityEngine;

namespace Defenses.DefenseCharacters.BombAnt
{
    public class BombDefenseCharacter : DefenseCharacterBase
    {
        [SerializeField] private int attackDamage;
        [SerializeField] private GameObject bombPrefab;
        [SerializeField] private float bombSpeed;
        [SerializeField] private float bombAOERadius;
        [SerializeField] private Transform bombSpawnPoint;
        [SerializeField] private GameObject heldBomb;

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
            heldBomb.SetActive(true);
        }

        public void ReleaseBomb()
        {
            if (target == null || heldBomb == null) return;

            heldBomb.SetActive(false);
            Projectile spear = Instantiate(bombPrefab, bombSpawnPoint.position, bombSpawnPoint.rotation)
                .GetComponent<Projectile>();
            spear.InitializeProjectile(target, bombSpeed, attackDamage);
        }

        public void RestoreHeldBomb()
        {
            if (heldBomb != null)
                heldBomb.SetActive(true);
        }
    }
}