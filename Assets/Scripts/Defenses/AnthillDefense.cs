using System;
using Defenses.DefenseCharacters;
using DG.Tweening;
using UnityEngine;

public class AnthillDefense : UpgradeableDefense
{
    [Header("Production")] [SerializeField]
    private int currencyAmount = 10;

    [SerializeField] private float productionRate = 10f;

    [Header("Coin Visual")] [SerializeField]
    private Transform coinRoot;

    [SerializeField] private ParticleSystem currencyShine;
    [SerializeField] private float riseHeight = 1f;
    [SerializeField] private float riseDuration = 0.4f;
    [SerializeField] private float bobHeight = 0.2f;
    [SerializeField] private float bobHalfDuration = 0.3f;
    [SerializeField] private int bobCycles = 3;
    [SerializeField] private float fallDuration = 0.35f;
    [SerializeField] private Transform coinVisual;
    [SerializeField] private float spinDegreesPerSecond = 180f;

    [Header("Upgrades")] [SerializeField] private DefenseUpgradeData upgradeData;
    [SerializeField] private DefenseUpgradeData secondUpgradeData;
    [SerializeField] private GameObject upgradeEffect1Prefab;
    [SerializeField] private GameObject upgradeEffect2Prefab;
    [SerializeField] private Transform upgradeEffectPoint;

    private CurrencyManager currency;
    private Sequence productionSequence;
    private Vector3 restingPosition;
    private Vector3 visibleScale;
    private float elapsedTime;
    private int upgradesPurchased;
    private bool placed;
    private bool producing;
    private bool upgradeInProgress;
    private Quaternion restingCoinRotation;

    public override DefenseUpgradeData UpgradeData => upgradesPurchased switch
    {
        0 => upgradeData,
        1 => secondUpgradeData,
        _ => null
    };

    public override int CurrentLevel => upgradesPurchased + 1;
    public override bool IsDead => false;

    public override event Action OnDefenseUpgraded;

    private void Awake()
    {
        restingPosition = coinRoot.localPosition;
        visibleScale = coinRoot.localScale;
        restingCoinRotation = coinVisual.localRotation;
        HideCoin();
    }

    public void Initialize(CurrencyManager currencyManager)
    {
        if (placed)
            return;

        currency = currencyManager;
        elapsedTime = 0f;
        placed = true;
    }

    private void Update()
    {
        elapsedTime += Time.deltaTime;

        if (elapsedTime >= productionRate)
            ProduceCurrency();
    }

    private void ProduceCurrency()
    {
        producing = true;
        elapsedTime = 0f;
        int payout = currencyAmount;

        coinRoot.localPosition = restingPosition;
        coinRoot.localScale = Vector3.zero;
        coinRoot.gameObject.SetActive(true);

        currencyShine.gameObject.SetActive(true);
        currencyShine.Stop(true, ParticleSystemStopBehavior.StopEmittingAndClear);
        currencyShine.Play();

        float raisedY = restingPosition.y + riseHeight;

        productionSequence = DOTween.Sequence();
        productionSequence.Append(coinRoot.DOLocalMoveY(raisedY, riseDuration).SetEase(Ease.OutCubic));
        productionSequence.Join(coinRoot.DOScale(visibleScale, riseDuration).SetEase(Ease.OutBack));
        productionSequence.Append(coinRoot.DOLocalMoveY(raisedY + bobHeight, bobHalfDuration).SetEase(Ease.InOutSine)
            .SetLoops(bobCycles * 2, LoopType.Yoyo));
        productionSequence.Append(coinRoot.DOLocalMoveY(restingPosition.y, fallDuration).SetEase(Ease.InCubic));
        productionSequence.Join(coinRoot.DOScale(Vector3.zero, fallDuration).SetEase(Ease.InCubic));
        float animationDuration = productionSequence.Duration();
        productionSequence.Insert(0f,
            coinVisual.DOLocalRotate(new Vector3(0f, 0f, spinDegreesPerSecond * animationDuration), animationDuration,
                RotateMode.LocalAxisAdd).SetEase(Ease.Linear));
        productionSequence.OnComplete(() =>
        {
            productionSequence = null;
            HideCoin();
            producing = false;
            currency.AddCurrency(payout);
        });
    }

    private void HideCoin()
    {
        currencyShine.Stop(true, ParticleSystemStopBehavior.StopEmittingAndClear);
        if (coinRoot == null)
            return;

        coinRoot.localPosition = restingPosition;
        coinRoot.localScale = visibleScale;
        coinVisual.localRotation = restingCoinRotation;
        coinRoot.gameObject.SetActive(false);
    }

    public override float GetUpgradeValue(DefenseUpgradeType type)
    {
        return type switch
        {
            DefenseUpgradeType.CurrencyProductionAmount => currencyAmount,
            DefenseUpgradeType.CurrencyProductionSpeed => productionRate,
            _ => -1f
        };
    }

    public override bool TryUpgrade(CurrencyManager wallet)
    {
        DefenseUpgradeData nextUpgrade = UpgradeData;

        if (upgradeInProgress)
            return false;

        upgradeInProgress = true;

        try
        {
            if (!wallet.TrySpend(nextUpgrade.Cost))
                return false;

            foreach (var upgrade in nextUpgrade.Upgrades)
            {
                switch (upgrade.UpgradeType)
                {
                    case DefenseUpgradeType.CurrencyProductionAmount:
                        currencyAmount = Mathf.RoundToInt(upgrade.UpgradedValue);
                        break;
                    case DefenseUpgradeType.CurrencyProductionSpeed:
                        productionRate = upgrade.UpgradedValue;
                        break;
                }
            }

            upgradesPurchased++;
        }
        finally
        {
            upgradeInProgress = false;
        }

        OnDefenseUpgraded?.Invoke();
        return true;
    }

    private void OnDisable()
    {
        productionSequence?.Kill();
        productionSequence = null;
        producing = false;
        elapsedTime = 0f;
        HideCoin();
    }
}