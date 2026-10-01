using PCG;
using StateMachine;
using UnityEngine;

namespace Enemy.RangerEnemy
{
    public class RangerEnemy : EnemyBase
    {
        [Header("Movement")] 
        [SerializeField] private int maxTilesToAdvance = 6;
        [SerializeField] private int minTilesToAdvance = 3;
        [SerializeField] private float minTowerDistance = 10f;
        
        [Header("Shooting")]
        [SerializeField] private Projectile bulletPrefab;
        [SerializeField] private Transform[] bulletSpawnPoints;
        [SerializeField] private float bulletSpeed = 15f;

        private static readonly int shootHash = Animator.StringToHash("Shoot");
        private bool shotPending;
        private int nextPairIndex;
        
        public int TilesToAdvance => Random.Range(minTilesToAdvance, maxTilesToAdvance + 1);
        public float MinTowerDistance => minTowerDistance;
        
        public override void Initialize(Transform target, Path path)
        {
            base.Initialize(target, path);
            if (target == null || path == null || path.TileCount < 2)
                return;

            var rangerWalkState = new RangerEnemyWalkState(this, animator, agent, path);
            walkState = rangerWalkState;
            attackState = new RangerEnemyAttackState(this, animator, agent, path);
           
            At(walkState, attackState, new FuncPredicate(() => rangerWalkState.HasReachedFiringPosition));
            
            stateMachine.SetState(walkState);
        }

        public override void Attack()
        {
            if (shotPending)
                return;

            base.Attack();
        }

        protected override void PerformAttack()
        {
            if (currentTarget == null)
                return;

            nextPairIndex = 0;
            shotPending = true;
            animator.Play(shootHash, 0, 0f);
        }

        public void ShootPair(int pairIndex)
        {
            if (!shotPending || pairIndex < 0 || pairIndex > 1 || pairIndex != nextPairIndex)
                return;

            nextPairIndex++;
            if (currentTarget == null)
                return;
            
            int firstSpawnIndex = pairIndex * 2;
            
            SpawnBullet(firstSpawnIndex);
            SpawnBullet(firstSpawnIndex + 1);
        }

        private void SpawnBullet(int spawnIndex)
        {
            Transform spawnPoint = bulletSpawnPoints[spawnIndex];
            
            Projectile bullet = Instantiate(bulletPrefab, spawnPoint.position, spawnPoint.rotation);
            bullet.InitializeProjectile(currentTarget, bulletSpeed, EnemyData.AttackDamage);
            ReportProjectileSpawned(bullet);
        }

        public void FinishShooting()
        {
            shotPending = false;
        }
    }
}