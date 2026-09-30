using System.Collections.Generic;
using Defenses.DefenseCharacters;
using PCG;
using StateMachine;
using UnityEngine;

namespace Enemy.SwarmerEnemy
{
    public class SwarmerEnemy : EnemyBase
    {
        private SwarmerEnemyWalkState swarmerEnemyWalkState;
        private Path path;
        private GridTile[,] grid;
        private EnemyWaveManager waveManager;

        private readonly HashSet<int> seenDefense = new();

        public override void Initialize(Transform target, Path path)
        {
           Initialize(target, path, 1);
        }

        public void Initialize(Transform target, Path path, int startIndex)
        {
            base.Initialize(target, path);
            if (target == null || path == null || path.TileCount < 2)
                return;

            this.path = path;
            WorldGenerator worldGenerator = path.Tiles[0].GetComponentInParent<WorldGenerator>();
            if (worldGenerator == null)
                return;

            grid = worldGenerator.Grid;

            swarmerEnemyWalkState = new SwarmerEnemyWalkState(this, animator, agent, path, startIndex);
            walkState = swarmerEnemyWalkState;
            attackState = new SwarmerEnemyAttackState(this, animator, agent);
            swarmerEnemyWalkState.PathTileChanged += CheckForDefenseTargets;
            
            At(walkState, attackState, new FuncPredicate(() => swarmerEnemyWalkState.HasFinishedPath || HasDefenseTarget));
            At(attackState, walkState, new FuncPredicate(() => !HasDefenseTarget && !swarmerEnemyWalkState.HasFinishedPath));
            
            stateMachine.SetState(walkState);
        }

        private void CheckForDefenseTargets(int index)
        {
            if (HasDefenseTarget)
                return;
            
            GridTile previousPathTile = path.Tiles[index - 1];
            GridTile currentPathTile = path.Tiles[index];
            
            Vector2Int pathDirection = currentPathTile.Coordinates - previousPathTile.Coordinates;
            Vector2Int sideOffset = new Vector2Int(-pathDirection.y, pathDirection.x);
            Vector2Int leftCoordinates = currentPathTile.Coordinates + sideOffset;
            Vector2Int rightCoordinates = currentPathTile.Coordinates - sideOffset;

            TryTargetDefenseAt(leftCoordinates);
            
            if (!HasDefenseTarget)
                TryTargetDefenseAt(rightCoordinates);
        }
        
        private void TryTargetDefenseAt(Vector2Int coordinates)
        {
            if (coordinates.x < 0 || coordinates.x >= grid.GetLength(0) || coordinates.y < 0 ||
                coordinates.y >= grid.GetLength(1))
                return;
            
            GridTile tile = grid[coordinates.x, coordinates.y];
            GameObject occupant =  tile.Occupant;

            if (occupant == null || !occupant.TryGetComponent(out DefenseCharacterBase defense))
                return;
            
            if (defense.IsDead)
                return;

            int defenseID = defense.GetEntityId();

            if (!seenDefense.Add(defenseID))
                return;
            
            TryTargetDefense(defense);
        }

        public void SetWaveManager(EnemyWaveManager manager)
        {
            waveManager = manager;
        }

        protected override void PerformAttack()
        {
            if (currentTarget == null)
                return;

            if (!currentTarget.TryGetComponent<IDamageable>(out IDamageable damageable))
                return;
            
            DefenseCharacterBase attackedDefense = currentTarget.GetComponent<DefenseCharacterBase>();
            bool wasAlive = attackedDefense != null && !attackedDefense.IsDead;
            
            damageable.TakeDamage(EnemyData.AttackDamage);

            if (wasAlive && attackedDefense.IsDead)
                SpawnOffspring();
        }

        private void SpawnOffspring()
        {
            if (waveManager == null)
                return;
            Vector3 spawnPosition = transform.position + transform.right * (agent.radius * 2f + 0.1f);
            GameObject instance = Instantiate(EnemyData.prefab, spawnPosition, transform.rotation);

            if (!instance.TryGetComponent<SwarmerEnemy>(out var offspring))
            {
                Destroy(instance);
                return;
            }
            
            offspring.Initialize(towerTarget, path, swarmerEnemyWalkState.PathIndex);
            waveManager.RegisterEnemy(offspring);
        }
    }
}