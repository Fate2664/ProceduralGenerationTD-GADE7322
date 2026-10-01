using System;
using System.Collections.Generic;
using PCG;
using UnityEngine;
using UnityEngine.AI;

namespace Enemy
{
    public class CommonEnemyWalkState : EnemyBaseState
    {
        private readonly NavMeshAgent agent;
        private readonly Path path;
        
        private const float tileStoppingDistance = 0.1f;
        private const float finalStoppingDistance = 5.0f;
        private int pathIndex;
        private bool hasStarted;
        
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
            
            pathIndex++;
            SetCurrentDestination();
        }

        private void SetCurrentDestination()
        {
            GridTile tile = path.Tiles[pathIndex];
            
            //Get tile center
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