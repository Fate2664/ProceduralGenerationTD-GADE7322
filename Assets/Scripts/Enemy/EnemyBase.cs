using Systems;
using UnityEngine;
using UnityEngine.AI;

namespace Enemy
{
    public class EnemyBase : Entity
    {
        [SerializeField] private float timeBetweenAttacks = 1f;
        [SerializeField] private float moveSpeed = 1f;
        
        protected NavMeshAgent agent;
        protected Animator animator;

        private CountDownTimer attackTimer;
    }
}
