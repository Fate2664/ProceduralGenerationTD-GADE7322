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


    public class DefenseCharacterBase : DamageableDefense
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
        [SerializeField] private DefenseUpgradeData secondUpgradeData;
        [SerializeField] private GameObject upgradeEffect1Prefab;
        [SerializeField] private GameObject upgradeEffect2Prefab;
        [SerializeField] private Transform upgradeEffectPoint;

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
        private int upgradesPurchased;
        private bool upgradeInProgress;
        private GameObject upgradeEffectInstance;
        
        //Weather attack speed multiplier for rain and thunder storm weather
        private float WeatherAttackSpeedMultiplier => WeatherManager.Instance != null
            ? Mathf.Clamp(WeatherManager.Instance.DefenseAttackSpeedMultiplier, 0.1f, 1f)
            : 1f;

        private static readonly int AttackSpeedMultiplierId = Animator.StringToHash("AttackSpeedMultiplier");

        public int AttackDamage
        {
            get
            {
                float multiplier = WeatherManager.Instance != null ? WeatherManager.Instance.DefenseDamageMultiplier : 1f;
                return Mathf.RoundToInt(attackDamage * multiplier);
            }
        }

        public float CurrentHealth => currentHealth;
        public float MaxHealth => maxHealth;

        public override DefenseUpgradeData UpgradeData
        {
            get
            {
                switch (upgradesPurchased)
                {
                    case 0: return upgradeData;
                    case 1: return secondUpgradeData;
                    default: return null;
                }
            }
        }

        public bool IsUpgraded => upgradesPurchased > 0;
        public override int CurrentLevel => upgradesPurchased + 1;
        public override bool IsDead => currentHealth <= 0f;
        public event Action<DefenseCharacterBase> Died;
        public override event Action OnDefenseUpgraded;
        private float baseDetectionRadius;

        #endregion

        private void Awake()
        {
            animator = GetComponentInChildren<Animator>();
            enemyDetector = GetComponent<EnemyDetector>();
            healthBar = GetComponentInChildren<CharacterHealthBar>(true);
            stateMachine = new StateMachine.StateMachine();
            attackTimer = new CountDownTimer(timeBetweenAttacks);
            initialAttackInterval = timeBetweenAttacks;

            baseDetectionRadius = enemyDetector.DetectionRadius;
        }

        protected void At(IState from, IState to, IPredicate condition) =>
            stateMachine.AddTransition(from, to, condition);

        protected void Any(IState to, IPredicate condition) => stateMachine.AddAnyTransition(to, condition);

        private void Update()
        {
            if (stateMachine.CurrentState == null) return;
            
            animator.SetFloat(AttackSpeedMultiplierId, initialAttackInterval / timeBetweenAttacks * WeatherAttackSpeedMultiplier);
            
            enemyDetector.TickDetection(Time.deltaTime);
            UpdateFacing(Time.deltaTime);

            stateMachine.Update();
            attackTimer.Tick(Time.deltaTime * WeatherAttackSpeedMultiplier);
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
            animator.SetFloat(AttackSpeedMultiplierId, initialAttackInterval / timeBetweenAttacks * WeatherAttackSpeedMultiplier);
            PerformAttack();
            return true;
        }

        protected virtual void PerformAttack()
        {
        }

        #endregion

        #region TakingDamage

        public override void TakeDamage(int damage)
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
            NotifyDefenseDied();
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

        //This method returns the stat value for the upgrade type
        public override float GetUpgradeValue(DefenseUpgradeType type)
        {
            switch (type)
            {
                case DefenseUpgradeType.Damage:
                    return attackDamage;
                case DefenseUpgradeType.Range:
                    return baseDetectionRadius;
                case DefenseUpgradeType.AttackSpeed:
                    return 1f / timeBetweenAttacks;
                case DefenseUpgradeType.MaxHealth:
                    return maxHealth;
                default:
                    return -1f;
            }
        }
        
        
        public override bool TryUpgrade(CurrencyManager currency)
        {
            if (currency == null || IsDead || upgradeInProgress)
                return false;

            DefenseUpgradeData nextUpgrade = UpgradeData;
            if (nextUpgrade == null || nextUpgrade.Cost < 0 || nextUpgrade.Upgrades == null)
                return false;

            upgradeInProgress = true;

            try
            {
                //Spend the upgrade cost if they can afford it
                if (!currency.TrySpend(nextUpgrade.Cost))
                    return false;

                //Apply each stat upgrade for all the upgrade items in that upgrade tier
                foreach (var upgrade in nextUpgrade.Upgrades)
                {
                    ApplyUpgrade(upgrade.UpgradeType, upgrade.UpgradedValue);
                }

                upgradesPurchased++;
                UpdateUpgradeEffect();
            }
            finally
            {
                upgradeInProgress = false;
            }

            OnDefenseUpgraded?.Invoke();
            return true;
        }

        private void UpdateUpgradeEffect()
        {
            if (upgradesPurchased == 0)
                return;

            GameObject effectPrefab = upgradesPurchased == 1
                ? upgradeEffect1Prefab
                : upgradeEffect2Prefab;

            if (upgradeEffectInstance != null)
            {
                upgradeEffectInstance.SetActive(false);
                Destroy(upgradeEffectInstance);
            }

            upgradeEffectInstance = Instantiate(effectPrefab, upgradeEffectPoint.position, upgradeEffectPoint.rotation,
                upgradeEffectPoint);
        }
        
        //This methods sets the selected stat to the value defined by the upgrade item
        protected virtual void ApplyUpgrade(DefenseUpgradeType type, float upgradeValue)
        {
            switch (type)
            {
                case DefenseUpgradeType.Damage:
                    attackDamage = Mathf.RoundToInt(upgradeValue);
                    break;
                case DefenseUpgradeType.Range:
                    baseDetectionRadius = upgradeValue;
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