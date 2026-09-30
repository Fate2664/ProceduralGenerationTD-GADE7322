using PCG;
using UnityEngine;
using UnityEngine.AI;

namespace Enemy.RangerEnemy
{
    public class RangerEnemyWalkState : EnemyBaseState
    {
        private readonly RangerEnemy ranger;
        private readonly NavMeshAgent agent;
        private readonly Path path;
        private readonly int tilesToAdvance;

        private const float takeofftime = 0.2f;
        private const float landingTime = 0.8f;

        private int nextTileIndex = 1;
        private Vector3 jumpStart;
        private Vector3 jumpEnd;

        public bool HasReachedFiringPosition { get; private set; }

        public RangerEnemyWalkState(RangerEnemy ranger, Animator animator, NavMeshAgent agent, Path path) : base(ranger,
            animator)
        {
            this.ranger = ranger;
            this.agent = agent;
            this.path = path;
            tilesToAdvance = ranger.TilesToAdvance;
        }

        public override void OnEnter()
        {
            agent.isStopped = true;
            agent.ResetPath();
            agent.updatePosition = false;
            agent.updateRotation = false;

            BeginNextJump();
        }

        public override void Update()
        {
            if (HasReachedFiringPosition)
                return;

            AnimatorStateInfo stateInfo = animator.GetCurrentAnimatorStateInfo(0);

            if (stateInfo.shortNameHash != walkHash)
                return;

            float animationProgress = stateInfo.normalizedTime;
            float movementProgress = Mathf.InverseLerp(takeofftime, landingTime, animationProgress);
            Vector3 position = Vector3.Lerp(jumpStart, jumpEnd, movementProgress);

            ranger.transform.position = position;
            agent.nextPosition = position;

            if (animationProgress < 1f)
                return;

            ranger.transform.position = jumpEnd;
            agent.nextPosition = jumpEnd;

            nextTileIndex++;
            BeginNextJump();
        }

        private void BeginNextJump()
        {
            if (nextTileIndex > tilesToAdvance || nextTileIndex >= path.TileCount - 1 || ranger.CurrentTarget == null)
            {
                HasReachedFiringPosition = true;
                return;
            }

            Vector3 tilePosition = path.Tiles[nextTileIndex].transform.position;
            tilePosition.y = ranger.transform.position.y;

            if (!NavMesh.SamplePosition(tilePosition, out NavMeshHit hit, 0.5f, agent.areaMask))
            {
                HasReachedFiringPosition = true;
                return;
            }

            Vector3 towerOffset = hit.position - ranger.CurrentTarget.position;
            towerOffset.y = 0f;

            float minDistance = ranger.MinTowerDistance;

            if (towerOffset.sqrMagnitude < minDistance * minDistance)
            {
                HasReachedFiringPosition = true;
                return;
            }

            jumpStart = ranger.transform.position;
            jumpEnd = hit.position;

            Vector3 direction = jumpEnd - jumpStart;
            direction.y = 0f;

            if (direction.sqrMagnitude > 0.001f)
            {
                ranger.transform.rotation = Quaternion.LookRotation(direction);
            }

            animator.Play(walkHash, 0, 0f);
            animator.Update(0f);
        }

        public override void OnExit()
        {
            agent.Warp(ranger.transform.position);
            agent.updatePosition = true;
            agent.updateRotation = true;
        }
    }
}