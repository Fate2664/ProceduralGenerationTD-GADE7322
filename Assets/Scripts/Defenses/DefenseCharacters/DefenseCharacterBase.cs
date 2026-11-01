using System;
using System.Collections.Generic;
using StateMachine;
using Systems;
using UI;
using UnityEngine;

namespace Defenses.DefenseCharacters
{
    public enum DefenseCharacterType
    {
        Spear,
        Melee,
        AOE
    }

    public class DefenseCharacterBase : Entity, IDamageable
    {
        #region Inspector Variables

        [SerializeField] private int attackDamage;
        [SerializeField] private float timeBetweenAttacks = 1.47f; //This must be the time of the attack animation  
        [SerializeField] private float turnSpeed = 360.0f;
        [SerializeField] private float maxHealth = 10f;
        [SerializeField] private GameObject damageEffectPrefab;
        [SerializeField] private Transform damageEffectPoint;
        [SerializeField] private DefenseCharacterType defenseCharacterType = DefenseCharacterType.Spear;
        [SerializeField] private DefenseUpgradeData upgradeData;

        #endregion

        #region Local Variables

        protected StateMachine.StateMachine stateMachine;
        protected Animator animator;
        protected EnemyDetector enemyDetector;

        protected IState idleState;
        protected IState attackState;

        protected CountDownTimer attackTimer;

        private CharacterHealthBar healthBar;
        private Transform pathTarget;
        private float currentHealth;
        private float initialAttackInterval;
        private bool isUpgraded;
        private bool upgradeInProgress;

        private static readonly int AttackSpeedMultiplierId = Animator.StringToHash("AttackSpeedMultiplier");

        public int AttackDamage => attackDamage;
        public float CurrentHealth => currentHealth;
        public float MaxHealth => maxHealth;
        public DefenseUpgradeData UpgradeData => upgradeData;
        public bool IsUpgraded => isUpgraded;
        public int CurrentLevel => isUpgraded ? 2 : 1;
        public bool IsDead => currentHealth <= 0f;
        public event Action<DefenseCharacterBase> Died;
        public event Action OnDefenseUpgraded;

        #endregion

        private void Awake()
        {
            animator = GetComponentInChildren<Animator>();
            enemyDetector = GetComponent<EnemyDetector>();
            healthBar = GetComponentInChildren<CharacterHealthBar>(true);
            stateMachine = new StateMachine.StateMachine();
            attackTimer = new CountDownTimer(timeBetweenAttacks);
            initialAttackInterval = timeBetweenAttacks;
        }

        protected void At(IState from, IState to, IPredicate condition) => stateMachine.AddTransition(from, to, condition);
        protected void Any(IState to, IPredicate condition) => stateMachine.AddAnyTransition(to, condition);
        
        private void Update()
        {
            if (stateMachine.CurrentState == null) return;

            enemyDetector.TickDetection(Time.deltaTime);
            UpdateFacing(Time.deltaTime);

            stateMachine.Update();
            attackTimer.Tick(Time.deltaTime);
        }

        private void FixedUpdate()
        {
            if (stateMachine.CurrentState == null) return;

            stateMachine.FixedUpdate();
        }

        public virtual void Initialize(Transform nearestPath = null)
        {
            pathTarget = nearestPath;
            currentHealth = maxHealth;
            healthBar?.SetHealth(currentHealth, maxHealth);

            if (pathTarget != null)
            {
                Vector3 direction = pathTarget.position - transform.position;
                direction.y = 0f;

                if (direction.sqrMagnitude <= Mathf.Epsilon)
                    return;

                transform.rotation = Quaternion.LookRotation(direction, Vector3.up);
            }
        }

        private void UpdateFacing(float deltaTime)
        {
            //Enemies take priority over path
            Transform facingTarget = enemyDetector.Enemy != null ? enemyDetector.Enemy : pathTarget;

            if (facingTarget == null) return;

            Vector3 direction = facingTarget.position - transform.position;
            direction.y = 0f;

            if (direction.sqrMagnitude <= Mathf.Epsilon)
                return;

            Quaternion targetRotation = Quaternion.LookRotation(direction.normalized, Vector3.up);
            transform.rotation = Quaternion.RotateTowards(transform.rotation, targetRotation, turnSpeed * deltaTime);
        }

        #region Attacking

        public virtual bool Attack()
        {
            if (attackTimer.IsRunning) return false;

            attackTimer.Reset(timeBetweenAttacks);
            attackTimer.Start();
            animator.SetFloat(AttackSpeedMultiplierId, initialAttackInterval / timeBetweenAttacks);
            PerformAttack();
            return true;
        }

        protected virtual void PerformAttack()
        {
        }

        #endregion

        #region TakingDamage

        public void TakeDamage(int damage)
        {
            if (currentHealth <= 0)
                return;

            PlayDamageEffect();

            currentHealth = Mathf.Max(0, currentHealth - damage);
            healthBar?.SetHealth(currentHealth, maxHealth);

            if (currentHealth <= 0)
                Die();
        }

        private void Die()
        {
            Died?.Invoke(this);
            Destroy(gameObject);
        }

        private void PlayDamageEffect()
        {
            Vector3 position = damageEffectPoint.position;
            Quaternion rotation = damageEffectPoint.rotation;
            Instantiate(damageEffectPrefab, position, rotation);
        }

        #endregion

        #region Upgrading

        public virtual float GetUpgradeValue(DefenseUpgradeType type)
        {
            switch (type)
            {
                case DefenseUpgradeType.Damage:
                    return attackDamage;
                case DefenseUpgradeType.Range:
                    return enemyDetector.DetectionRadius;
                case DefenseUpgradeType.AttackSpeed:
                    return 1f / timeBetweenAttacks;
                case DefenseUpgradeType.MaxHealth:
                    return maxHealth;
                default:
                    return -1f;
            }
        }

        public bool TryUpgrade( CurrencyManager currency)
        {
            upgradeInProgress = true;
            
            try
            {

                if (!currency.TrySpend(upgradeData.Cost))
                    return false;

                foreach (var upgrade in upgradeData.Upgrades)
                {
                    ApplyUpgrade(upgrade.UpgradeType, upgrade.UpgradedValue);
                }
                
                isUpgraded =  true;
            }
            finally
            {
                upgradeInProgress = false;
            }

            OnDefenseUpgraded?.Invoke();
            return true;
        }

        protected virtual void ApplyUpgrade(DefenseUpgradeType type, float upgradeValue)
        {
            switch (type)
            {
                case DefenseUpgradeType.Damage:
                    attackDamage = Mathf.RoundToInt(upgradeValue);
                    break;
                case DefenseUpgradeType.Range:
                    enemyDetector.SetDetectionRadius(upgradeValue);
                    break;
                case DefenseUpgradeType.AttackSpeed:
                    timeBetweenAttacks = 1f / upgradeValue;
                    break;
                case DefenseUpgradeType.MaxHealth:
                    currentHealth += upgradeValue - maxHealth;
                    maxHealth = upgradeValue;
                    healthBar?.SetHealth(currentHealth, maxHealth);
                    break;
            }
        }

        #endregion
    }
}