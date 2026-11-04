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


    public class DefenseCharacterBase : UpgradeableDefense, IDamageable 
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

        private static readonly int AttackSpeedMultiplierId = Animator.StringToHash("AttackSpeedMultiplier");

        public int AttackDamage => attackDamage;
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

        public static List<DefenseCharacterBase> All = new List<DefenseCharacterBase>();
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
            ApplyWeatherRange();
        }

        protected void At(IState from, IState to, IPredicate condition) =>
            stateMachine.AddTransition(from, to, condition);

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

        private void OnEnable()
        {
            All.Add(this);
            WeatherManager.OnWeatherChanged += HandleWeatherChanged;
        }

        private void OnDisable()
        {
            All.Remove(this);
            WeatherManager.OnWeatherChanged -= HandleWeatherChanged;
        }


        private void HandleWeatherChanged(WeatherManager.WeatherType newWeather)
        {
            ApplyWeatherRange();
        }

        private void ApplyWeatherRange()
        {
            float mult = WeatherManager.Instance != null ? WeatherManager.Instance.currTowerRangeMult : 1f;
            enemyDetector.SetDetectionRadius(baseDetectionRadius * mult);
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
                if (!currency.TrySpend(nextUpgrade.Cost))
                    return false;

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

        protected virtual void ApplyUpgrade(DefenseUpgradeType type, float upgradeValue)
        {
            switch (type)
            {
                case DefenseUpgradeType.Damage:
                    attackDamage = Mathf.RoundToInt(upgradeValue);
                    break;
                case DefenseUpgradeType.Range:
                    baseDetectionRadius = upgradeValue;
                    ApplyWeatherRange();
                    //enemyDetector.SetDetectionRadius(upgradeValue);
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