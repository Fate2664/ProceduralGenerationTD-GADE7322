using System.Collections.Generic;
using Defenses.DefenseCharacters;
using Nova;
using PCG;
using StateMachine;
using UnityEngine;

namespace Enemy
{
    public class CommonEnemy : EnemyBase
    {
        private EnemyWalkState enemyWalkState;
        private List<GameObject> path;
        private GridTile[,] grid;

        private readonly HashSet<int> seenDefense = new();
        
        public override void Initialize(Transform target, List<GameObject> path)
        {
            base.Initialize(target, path);
            if (target == null || path == null || path.Count < 2)
                return;
            
            this.path = path;
            WorldGenerator worldGenerator = path[0].GetComponentInParent<WorldGenerator>();
            if (worldGenerator == null)
                return;
            
            grid = worldGenerator.Grid;
            
            enemyWalkState = new EnemyWalkState(this, animator, agent, path);
            walkState = enemyWalkState;
            attackState = new EnemyAttackState(this, animator, agent);
            enemyWalkState.PathTileChanged += CheckForDefenseTargets;
            
            At(walkState, attackState, new FuncPredicate(() => enemyWalkState.HasFinishedPath || HasDefenseTarget));  
            At(attackState, walkState, new FuncPredicate(() => !HasDefenseTarget && !enemyWalkState.HasFinishedPath));  
            
            stateMachine.SetState(walkState);
        }

        private void CheckForDefenseTargets(int index)
        {
            if (HasDefenseTarget)
                return;
            
            GridTile previousPathTile = path[index - 1].GetComponent<GridTile>();
            GridTile currentPathTile = path[index].GetComponent<GridTile>();
            
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

            int defenseID = defense.GetEntityId();

            if (!seenDefense.Add(defenseID))
                return;
            
            TryTargetDefense(defense);
        }

        protected override void PerformAttack()
        {
            if (currentTarget == null) 
                return;
            
            //Attack tower if it is close enough
            if (currentTarget.TryGetComponent<IDamageable>(out var damageable))
                damageable.TakeDamage(EnemyData.AttackDamage);
        }

    }
}