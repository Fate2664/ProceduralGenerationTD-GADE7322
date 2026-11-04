using System;
using System.Collections.Generic;
using Defenses.DefenseCharacters;
using PCG;
using Systems;
using UnityEngine;

public class Tower : UpgradeableDefense, IDamageable
{
    [Header("Stats")] [SerializeField] private int maxHealth = 100;
    [SerializeField] private int attackDamage = 2;
    [SerializeField] private float timeBetweenAttacks = 1f;

    [Header("Upgrades")] [SerializeField] private DefenseUpgradeData upgradeData;
    [SerializeField] private DefenseUpgradeData secondUpgradeData;
    [SerializeField] private Transform upgradeEffectPoint;
    [SerializeField] private GameObject upgradeEffect1Prefab;
    [SerializeField] private GameObject upgradeEffect2Prefab;

    private WorldGenerator worldGenerator;
    private CountDownTimer attackTimer;
    private List<GridTile> surroundingTiles;
    private Animator animator;
    private float currentHealth;
    private int upgradesPurchased;
    private bool upgradeInProgress;
    private GameObject upgradeEffectInstance;
    private static readonly int AttackTrigger = Animator.StringToHash("Attack");

    public override DefenseUpgradeData UpgradeData
    {
        get
        {
            switch (upgradesPurchased)
            {
                case 0:
                    return upgradeData;
                case 1:
                    return secondUpgradeData;
                default:
                    return null;
            }
        }
    }

    public event Action<float> OnHealthChanged;
    public event Action<float> Damaged;
    public override event Action OnDefenseUpgraded;

    public float CurrentHealth => currentHealth;
    public override int CurrentLevel => upgradesPurchased + 1;
    public override bool IsDead => currentHealth <= 0f;
    public float MaxHealth => maxHealth;
    public float HealthPercentage => currentHealth / maxHealth;


    private void Awake()
    {
        worldGenerator = GetComponentInParent<WorldGenerator>();
        animator = GetComponentInChildren<Animator>();
        attackTimer = new CountDownTimer(timeBetweenAttacks);

        currentHealth = maxHealth;
    }

    private void Start()
    {
        surroundingTiles = GetSurroundingTiles();
    }

    private void Update()
    {
        attackTimer.Tick(Time.deltaTime);

        if (attackTimer.IsRunning)
            return;

        if (AttackEnemiesOnSurroundingTiles())
        {
            animator.SetTrigger(AttackTrigger);
        }

        attackTimer.Start();
    }

    private List<GridTile> GetSurroundingTiles()
    {
        int centerX = worldGenerator.Grid.GetLength(0) / 2;
        int centerZ = worldGenerator.Grid.GetLength(1) / 2;

        return new List<GridTile>
        {
            //Left
            worldGenerator.Grid[centerX - 1, centerZ],
            //Right
            worldGenerator.Grid[centerX + 1, centerZ],
            //Top
            worldGenerator.Grid[centerX, centerZ - 1],
            //Bottom
            worldGenerator.Grid[centerX, centerZ + 1]
        };
    }

    private bool AttackEnemiesOnSurroundingTiles()
    {
        float halfTileSize = worldGenerator.GridOffset * .5f;
        bool attackedEnemy = false;

        foreach (var enemy in GameObject.FindGameObjectsWithTag("Enemy"))
        {
            foreach (GridTile tile in surroundingTiles)
            {
                Vector3 offset = enemy.transform.position - tile.transform.position;
                bool isOnTile = Mathf.Abs(offset.x) <= halfTileSize && Mathf.Abs(offset.z) <= halfTileSize;
                if (!isOnTile)
                    continue;

                if (enemy.TryGetComponent<IDamageable>(out IDamageable damageable))
                {
                    damageable.TakeDamage(attackDamage);
                    attackedEnemy = true;
                }

                break;
            }
        }

        return attackedEnemy;
    }

    public void TakeDamage(int attackDamage)
    {
        if (currentHealth <= 0f || attackDamage <= 0)
            return;

        float previousHealth = currentHealth;
        currentHealth = Mathf.Max(currentHealth - attackDamage, 0f);
        float actualDamage = previousHealth - currentHealth;

        Damaged?.Invoke(actualDamage);
        OnHealthChanged?.Invoke(HealthPercentage);

        if (currentHealth <= 0f)
        {
            Destroy(gameObject);
            Debug.Log("Tower has been destroyed");
        }
    }

    #region Upgrades

    public override float GetUpgradeValue(DefenseUpgradeType type)
    {
        switch (type)
        {
            case DefenseUpgradeType.Damage:
                return attackDamage;

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

    private void ApplyUpgrade(DefenseUpgradeType type, float value)
    {
        switch (type)
        {
            case DefenseUpgradeType.Damage:
                attackDamage = Mathf.RoundToInt(value);
                break;

            case DefenseUpgradeType.AttackSpeed:
                timeBetweenAttacks = 1f / value;
                attackTimer.Reset(timeBetweenAttacks);
                attackTimer.Start();
                break;

            case DefenseUpgradeType.MaxHealth:
                int upgradedMaxHealth = Mathf.RoundToInt(value);

                currentHealth += upgradedMaxHealth - maxHealth;
                maxHealth = upgradedMaxHealth;

                OnHealthChanged?.Invoke(HealthPercentage);
                break;
        }
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

    #endregion
}