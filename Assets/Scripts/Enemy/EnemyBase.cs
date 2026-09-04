using System;
using System.Collections.Generic;
using Defenses.DefenseCharacters;
using StateMachine;
using Systems;
using UnityEngine;
using UnityEngine.AI;

namespace Enemy
{
    public class EnemyBase : Entity, IDamageable
    {
        [SerializeField] private EnemyData enemyData;
        [SerializeField] private GameObject damageEffectPrefab;
        [SerializeField] private Transform damageEffectPoint;

        protected EnemyData EnemyData => enemyData;
        protected StateMachine.StateMachine stateMachine;
        protected NavMeshAgent agent;
        protected Animator animator;
        protected Transform currentTarget;
        protected Transform towerTarget;
        protected DefenseCharacterBase defenseTarget;

        protected IState walkState;
        protected IState attackState;
        
        protected CountDownTimer attackTimer;
        protected bool HasDefenseTarget => defenseTarget != null;
        
        public Transform CurrentTarget => currentTarget;
        public event Action<EnemyBase> Died;

        private float currentHealth;

        protected virtual void Awake()
        {
            agent = GetComponent<NavMeshAgent>();
            animator = GetComponentInChildren<Animator>();

            currentHealth = enemyData.MaxHealth;

            stateMachine = new StateMachine.StateMachine();
            attackTimer = new CountDownTimer(enemyData.TimeBetweenAttacks);
            agent.speed = enemyData.MoveSpeed;
        }

        protected void At(IState from, IState to, IPredicate condition) => stateMachine.AddTransition(from, to, condition);
        protected void Any(IState to, IPredicate condition) => stateMachine.AddAnyTransition(to, condition);

        private void Update()
        {
            if (stateMachine.CurrentState == null) return;
            
            stateMachine.Update();
            attackTimer.Tick(Time.deltaTime);
        }

        private void FixedUpdate()
        {
            if (stateMachine.CurrentState == null) return;
            
            stateMachine.FixedUpdate();
        }

        public virtual void Initialize(Transform target, List<GameObject> path)
        {
            towerTarget = target;
            currentTarget = target;
        }

        public bool PlaceOnNavMesh(Vector3 position, float maxDistance = 3f)
        {
            int areaMask = agent.areaMask;
            if (!NavMesh.SamplePosition(position, out NavMeshHit hit, maxDistance, areaMask))
                return false;
            
            agent.enabled = false;
            transform.position = hit.position;
            agent.enabled = true;

            return agent.isOnNavMesh;
        }        

        public virtual void Attack()
        {
            if (attackTimer.IsRunning) return;
            
            PerformAttack();
            attackTimer.Start();
        }
        
        protected virtual void PerformAttack() {}

        public void TakeDamage(int damage)
        {
            if (currentHealth <= 0)
                return;

            PlayDamageEffect();
            
            currentHealth = Mathf.Max(0, currentHealth - damage);

            if (currentHealth <= 0)
                Die();
        }

        protected bool TryTargetDefense(DefenseCharacterBase defenseCharacter)
        {
            if (defenseTarget != null)
                return false;
            
            if (UnityEngine.Random.value > EnemyData.ChanceToAttackDefenses)
                return false;
            
            defenseTarget = defenseCharacter;
            currentTarget = defenseCharacter.transform;
            defenseTarget.Died += HandleDefenseDied;
            return true;
        }

        public void HandleDefenseDied(DefenseCharacterBase defenseCharacter)
        {
            if (defenseCharacter != defenseTarget)
                return;

            defenseTarget.Died -= HandleDefenseDied;
            defenseTarget = null;
            currentTarget = towerTarget;
        }

        protected virtual void PlayDamageEffect()
        {
            Vector3 position = damageEffectPoint.position;
            Quaternion rotation = damageEffectPoint.rotation;
            Instantiate(damageEffectPrefab, position, rotation);
        }

        protected virtual void Die()
        {
            Died?.Invoke(this);
            
            //Death effects
            Destroy(gameObject);
        }
    }
}
