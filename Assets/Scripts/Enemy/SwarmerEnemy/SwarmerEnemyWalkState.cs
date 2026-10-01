using System;
using PCG;
using UnityEngine;
using UnityEngine.AI;

namespace Enemy.SwarmerEnemy
{
    public class SwarmerEnemyWalkState : EnemyBaseState
    {
        private readonly NavMeshAgent agent;
        private readonly Path path;

        private const float tileStoppingDistance = 0.1f;
        private const float finalStoppingDistance = 5.0f;
        private int pathIndex;

        public int PathIndex => pathIndex;
        public bool HasFinishedPath { get; private set; }
        public event Action<int> PathTileChanged;
        
        public SwarmerEnemyWalkState(EnemyBase enemyBase, Animator animator, NavMeshAgent agent, Path path, int startIndex = 1) : base(enemyBase, animator)
        {
            this.agent = agent;
            this.path = path;
            pathIndex = Mathf.Clamp(startIndex, 1, path.TileCount - 1);
        }

        public override void OnEnter()
        {
            animator.CrossFade(walkHash, crossFadeDuration);
            agent.isStopped = false;

            HasFinishedPath = false;
            SetCurrentDestination();
        }

        public override void Update()
        {
            if (HasFinishedPath || !HasReachedCurrentDestination())
                return;

            if (pathIndex >= path.TileCount - 1)
            {
                HasFinishedPath = true;
                EnemyBase.ReportReachedTower();
                return;
            }
            
            pathIndex++;
            SetCurrentDestination();
        }

        private void SetCurrentDestination()
        {
            GridTile tile = path.Tiles[pathIndex];
            
            Vector3 tileCenter = tile.GetComponentInChildren<Renderer>().bounds.center;

            if (!NavMesh.SamplePosition(tileCenter, out NavMeshHit hit, 3.0f, agent.areaMask))
                return;
            
            bool isFinalTile = pathIndex == path.TileCount - 1;
            agent.stoppingDistance = isFinalTile ? finalStoppingDistance : tileStoppingDistance;
            
            agent.SetDestination(hit.position);
            PathTileChanged?.Invoke(pathIndex);
        }

        public override void OnExit()
        {
            agent.stoppingDistance = finalStoppingDistance;
        }

        private bool HasReachedCurrentDestination()
        {
            if (!agent.isOnNavMesh || agent.pathPending || agent.pathStatus != NavMeshPathStatus.PathComplete)
                return false;
            
            return agent.remainingDistance <= agent.stoppingDistance;
        }
    }
}