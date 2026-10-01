using StateMachine;
using UnityEngine;

namespace Defenses.DefenseCharacters
{
    public class SpearDefenseCharacter : DefenseCharacterBase
    {
        [SerializeField] private int attackDamage;
        [SerializeField] private GameObject spearPrefab;
        [SerializeField] private float spearSpeed;
        [SerializeField] private Transform spearSpawnPoint;
        [SerializeField] private GameObject heldSpear;

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
            heldSpear.SetActive(true);
        }

        public void ReleaseSpear()
        {
            if (target == null || heldSpear == null) return;

            heldSpear.SetActive(false);
            Projectile spear = Instantiate(spearPrefab, spearSpawnPoint.position, spearSpawnPoint.rotation)
                .GetComponent<Projectile>();
            spear.InitializeProjectile(target, spearSpeed, attackDamage);
        }

        public void RestoreHeldSpear()
        {
            if (heldSpear != null)
                heldSpear.SetActive(true);
        }
    }
}