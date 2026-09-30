using PCG;
using UnityEngine;
using UnityEngine.AI;

namespace Enemy.RangerEnemy
{
    public class RangerEnemyAttackState : EnemyBaseState
    {
        private readonly NavMeshAgent agent;
        private readonly Path path;
        private readonly EnemyBase ranger;

        public RangerEnemyAttackState(EnemyBase ranger, Animator animator, NavMeshAgent agent, Path path) : base(ranger, animator)
        {
            this.ranger = ranger;
            this.agent = agent;
            this.path = path;
        }

        public override void OnEnter()
        {
            agent.isStopped = true;
            agent.updateRotation = false;
        }

        public override void Update()
        {
            Transform target = EnemyBase.CurrentTarget;
            if (target == null)
                return;

            Vector3 direction = target.position - EnemyBase.transform.position;
            direction.y = 0f;

            if (direction.sqrMagnitude > 0.001f)
            {
                Quaternion lookRotation = Quaternion.LookRotation(direction);
                EnemyBase.transform.rotation = Quaternion.RotateTowards(EnemyBase.transform.rotation, lookRotation,
                    agent.angularSpeed * Time.deltaTime);
            }

            EnemyBase.Attack();
        }

        public override void OnExit()
        {
            agent.updateRotation = true;
            agent.isStopped = false;
        }
    }
}