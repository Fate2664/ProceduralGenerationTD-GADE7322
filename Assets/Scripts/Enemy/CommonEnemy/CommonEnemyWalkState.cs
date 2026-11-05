using System;
using PCG;
using UnityEngine;
using UnityEngine.AI;

namespace Enemy
{
    public class CommonEnemyWalkState : EnemyBaseState
    {
        private readonly NavMeshAgent agent;
        private readonly Path path;
        
        private const float tileStoppingDistance = 0.05f;
        private const float finalStoppingDistance = 5.0f;
        private int pathIndex;
        private bool hasStarted;
        private bool hasDestination;
        
        public bool HasFinishedPath { get;  private set; }
        public event Action<int> PathTileChanged;
        
        public CommonEnemyWalkState(EnemyBase enemyBase, Animator animator, NavMeshAgent agent, Path path) : base(enemyBase, animator)
        {
            this.agent = agent;
            this.path = path;
        }

        public override void OnEnter()
        {
            animator.CrossFade(walkHash, crossFadeDuration);
            agent.isStopped = false;

            if (!hasStarted)
            {
                pathIndex = 1;
                hasStarted = true;
            }
            
            HasFinishedPath = false;
            SetCurrentDestination();
        }

        public override void Update()
        {
            if (HasFinishedPath || !HasReachedCurrentDestination())
                return;
            
            //If the current destination is the final - tower tile
            if (pathIndex >= path.TileCount - 1)
            {
                HasFinishedPath = true;
                EnemyBase.ReportReachedTower();
                return;
            }
            
            PathTileChanged?.Invoke(pathIndex);

            if (EnemyBase.HasDefenseTarget)
            {
                agent.isStopped = true;
                return;
            }
            
            pathIndex++;
            SetCurrentDestination();
        }

        private void SetCurrentDestination()
        {
            hasDestination = false;
            
            GridTile tile = path.Tiles[pathIndex];
            bool isFinalTile = pathIndex == path.TileCount - 1;
            
            //Get tile center
            Vector3 tileCenter = tile.transform.position;
            tileCenter.y = agent.destination.y;

            float sampleDistance = isFinalTile ? 3f : 0.5f;
            agent.stoppingDistance = isFinalTile ? finalStoppingDistance : tileStoppingDistance;

            if (!NavMesh.SamplePosition(tileCenter, out NavMeshHit hit, sampleDistance, agent.areaMask) || !agent.SetDestination(hit.position))
                return;

            hasDestination = true;
            agent.isStopped = false;
        }

        public override void OnExit()
        {
            agent.stoppingDistance = finalStoppingDistance;
        }

        private bool HasReachedCurrentDestination()
        {
            if (!hasDestination || !agent.isOnNavMesh || agent.pathPending || agent.pathStatus != NavMeshPathStatus.PathComplete)
                return false;
            
            return agent.remainingDistance <= agent.stoppingDistance;
        }
    }
}