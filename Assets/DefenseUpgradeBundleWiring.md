# One defense upgrade applies all three stat changes

This replaces the earlier independent-purchase design. The rows are read-only previews. The existing UpgradeButton buys the entire bundle for one price, and all three changes are applied to the selected character before the upgrade event is raised.

This version supports one bundle purchase per placed character: level 1 becomes level 2. Three stat changes do not mean three character levels. Multiple sequential bundle tiers would require a bundle array and current bundle index; that is not assumed here.

These are instructions and proposed code. No game scripts or scene/prefab references have been edited automatically.

## 1. DefenseUpgradeData.cs: move the price onto the bundle

Keep your current class and field names. Replace the file contents with:

```csharp
using System;
using UnityEngine;

namespace Defenses.DefenseCharacters
{
    public enum DefenseUpgradeType
    {
        Damage,
        Range,
        AttackSpeed,
        MaxHealth,
        AOE
    }

    [Serializable]
    public class DefenseUpgrade
    {
        [field: SerializeField] public DefenseUpgradeType UpgradeType { get; private set; }
        [field: SerializeField] public string DisplayName { get; private set; }
        [field: SerializeField] public Sprite Icon { get; private set; }
        [field: SerializeField, Min(0.01f)] public float UpgradedValue { get; private set; }
    }

    [CreateAssetMenu(menuName = "Defenses/Defense Upgrade")]
    public class DefenseUpgradeData : ScriptableObject
    {
        [field: SerializeField] public string DisplayName { get; private set; }
        [field: SerializeField] public Sprite Icon { get; private set; }
        [field: SerializeField, Min(0)] public int Cost { get; private set; }

        [SerializeField] private DefenseUpgrade[] upgrades = Array.Empty<DefenseUpgrade>();

        public DefenseUpgrade[] Upgrades => upgrades;
    }
}
```

`DefenseUpgrade` now describes one stat change. `DefenseUpgradeData` describes the purchasable bundle. Remove the old per-stat Cost values and `GetUpgrade(type)` method: purchasing no longer looks up a chosen type.

Set the new bundle Cost manually in existing assets. Unity will not automatically combine the old row prices. Configure exactly three distinct UpgradeType entries per bundle. UpgradedValue means the resulting stat value, not an amount to add. AttackSpeed is attacks per second; AOE is the bomb explosion radius.

## 2. DefenseCharacterBase.cs: replace per-stat purchases with one flag

Remove:

```csharp
private readonly HashSet<DefenseUpgradeType> purchasedUpgrades = new();
public int CurrentLevel => 1 + purchasedUpgrades.Count;
public bool HasUpgrade(DefenseUpgradeType upgrade) => purchasedUpgrades.Contains(upgrade);
```

Add:

```csharp
private bool hasUpgraded;
private bool upgradeInProgress;

public bool HasUpgraded => hasUpgraded;
public int CurrentLevel => hasUpgraded ? 2 : 1;
```

Keep `using System.Collections.Generic;` for bundle validation, plus your existing `UpgradeData` property and `OnDefenseUpgraded` event.

Add this property to validate the whole bundle before charging:

```csharp
public bool CanUpgrade
{
    get
    {
        if (IsDead || !isActiveAndEnabled || hasUpgraded || upgradeInProgress ||
            upgradeData == null || upgradeData.Cost < 0)
            return false;

        DefenseUpgrade[] upgrades = upgradeData.Upgrades;

        if (upgrades == null || upgrades.Length != 3)
            return false;

        var seenTypes = new HashSet<DefenseUpgradeType>();

        foreach (DefenseUpgrade upgrade in upgrades)
        {
            if (upgrade == null || !seenTypes.Add(upgrade.UpgradeType))
                return false;

            float currentValue = GetUpgradeValue(upgrade.UpgradeType);
            float nextValue = upgrade.UpgradedValue;

            if (currentValue < 0f || float.IsNaN(nextValue) ||
                float.IsInfinity(nextValue) || nextValue <= 0f || nextValue <= currentValue)
                return false;

            if (upgrade.UpgradeType == DefenseUpgradeType.Damage &&
                nextValue != Mathf.Round(nextValue))
                return false;
        }

        return true;
    }
}
```

Replace `TryUpgrade(DefenseUpgradeType type, CurrencyManager currency)` with:

```csharp
public bool TryUpgrade(CurrencyManager currency)
{
    if (currency == null || !CanUpgrade)
        return false;

    upgradeInProgress = true;

    try
    {
        if (!currency.TrySpend(upgradeData.Cost))
            return false;

        foreach (DefenseUpgrade upgrade in upgradeData.Upgrades)
        {
            ApplyUpgrade(upgrade.UpgradeType, upgrade.UpgradedValue);
        }

        hasUpgraded = true;
    }
    finally
    {
        upgradeInProgress = false;
    }

    OnDefenseUpgraded?.Invoke();
    return true;
}
```

The purchase method no longer accepts a stat type. It validates all three changes first, charges once, applies all three, marks the bundle purchased, then raises one upgrade event. The in-progress flag prevents synchronous BalanceChanged listeners from triggering a second purchase while the first is running. Insufficient funds leave all stats unchanged.

Keep your existing `GetUpgradeValue()` and `ApplyUpgrade()` methods and the bomb overrides. These are still responsible for reading/applying each individual stat. Unsupported types return -1, so a spear bundle containing AOE is rejected before spending currency.

Keep your current attack timer reset and AttackSpeedMultiplier code. Confirm the Attack state's multiplier is configured in each Animator Controller. An attack-speed change takes effect on the next attack, preserving the animation already playing.

## 3. Correct range values and melee reach

Your current `EnemyDetector.SetDetectionRadius()` rebuilds the strategy but does not update `detectionRadius`. Consequently, the UI continues to report the old range after purchasing the bundle.

Replace that method with:

```csharp
public void SetDetectionRadius(float radius)
{
    detectionRadius = Mathf.Max(0.01f, radius);
    innerDetectionRadius = Mathf.Min(innerDetectionRadius, detectionRadius);

    detectionStrategy = new ConeDetectionStrategy(
        detectionAngle,
        detectionRadius,
        innerDetectionRadius);

    FindNearestEnemy();
}
```

If a melee bundle contains Range, add these overrides to `MeleeDefenseCharacter`. Your current melee script still uses a separate `meleeRange`, so changing detection alone will not extend its hits:

```csharp
public override float GetUpgradeValue(DefenseUpgradeType type)
{
    return type == DefenseUpgradeType.Range
        ? meleeRange
        : base.GetUpgradeValue(type);
}

protected override void ApplyUpgrade(DefenseUpgradeType type, float upgradeValue)
{
    if (type == DefenseUpgradeType.Range)
    {
        meleeRange = upgradeValue;
        enemyDetector.SetDetectionRadius(upgradeValue);
        return;
    }

    base.ApplyUpgrade(type, upgradeValue);
}
```

Set the melee prefab's initial detection radius to its initial melee range, with inner radius no larger, for consistent targeting before the upgrade as well.

## 4. Replace DefenseUpgradeVisuals.cs

Each row displays a stat name/icon and its before/after values. It has no price, selection state, click handler, or independent Purchased state.

```csharp
using System;
using Defenses.DefenseCharacters;
using Nova;
using UnityEngine;

[Serializable]
public class DefenseUpgradeVisuals : ItemVisuals
{
    [SerializeField] private UIBlock2D Background;
    [SerializeField] private UIBlock2D UpgradeIcon;
    [SerializeField] private TextBlock UpgradeName;
    [SerializeField] private TextBlock CurrentAmount;
    [SerializeField] private TextBlock NewAmount;

    public void Bind(DefenseUpgrade upgrade, float currentValue)
    {
        UpgradeName.Text = string.IsNullOrWhiteSpace(upgrade.DisplayName)
            ? upgrade.UpgradeType.ToString()
            : upgrade.DisplayName;

        CurrentAmount.Text = currentValue < 0f
            ? "Unavailable"
            : FormatValue(upgrade.UpgradeType, currentValue);

        NewAmount.Text = FormatValue(upgrade.UpgradeType, upgrade.UpgradedValue);

        if (upgrade.Icon != null)
            UpgradeIcon.SetImage(upgrade.Icon);
        else
            UpgradeIcon.ClearImage();
    }

    private static string FormatValue(DefenseUpgradeType type, float value)
    {
        return type == DefenseUpgradeType.AttackSpeed
            ? $"{value:0.##}/s"
            : value.ToString("0.##");
    }
}
```

Keep the class in its current global namespace so the existing ItemView visuals reference remains valid. `[Serializable]` is required for the custom visuals fields. Background remains available for your prefab styling; no code changes its color here.

## 5. Replace DefenseUpgradeController.cs

This controller binds the three rows directly to the selected character's bundle. Only the separate UpgradeButton can purchase anything. After purchase, the rows show the new current values and the button says Upgraded. The level header changes once.

```csharp
using Defenses.DefenseCharacters;
using Nova;
using UnityEngine;

namespace Defenses
{
    public class DefenseUpgradeController : MonoBehaviour
    {
        [SerializeField] private CurrencyManager currency;
        [SerializeField] private DefenseHoverController hoverController;
        [SerializeField] private DefensePlacementManager placementManager;
        [SerializeField] private GameObject upgradeRoot;
        [SerializeField] private ListView upgradesList;
        [SerializeField] private UIBlock2D upgradeButton;
        [SerializeField] private TextBlock upgradeButtonText;
        [SerializeField] private TextBlock defenseTitle;
        [SerializeField] private TextBlock defenseLevel;
        [SerializeField] private UIBlock2D defenseIcon;
        [SerializeField] private UIBlock closeButton;

        private DefenseCharacterBase selectedCharacter;
        private Color enabledButtonColor;

        private void Awake()
        {
            enabledButtonColor = upgradeButton.Color;
            upgradesList.AddDataBinder<DefenseUpgrade, DefenseUpgradeVisuals>(BindUpgrade);
            upgradeButton.AddGestureHandler<Gesture.OnClick>(HandlePurchase);

            if (closeButton != null)
                closeButton.AddGestureHandler<Gesture.OnClick>(HandleClose);

            upgradeRoot.SetActive(false);
        }

        private void OnEnable()
        {
            hoverController.DefenseSelected += HandleSelectedCharacter;
            currency.BalanceChanged += Refresh;
        }

        private void OnDisable()
        {
            if (hoverController != null)
                hoverController.DefenseSelected -= HandleSelectedCharacter;

            if (currency != null)
                currency.BalanceChanged -= Refresh;

            ClearSelection();
        }

        private void Update()
        {
            if (selectedCharacter != null &&
                (!selectedCharacter.isActiveAndEnabled || placementManager.IsPlacingDefense))
                ClearSelection();
        }

        private void HandleSelectedCharacter(DefenseCharacterBase character)
        {
            ClearSelection();

            if (character == null || character.IsDead || character.UpgradeData == null)
                return;

            selectedCharacter = character;
            selectedCharacter.Died += HandleSelectedCharacterDied;
            selectedCharacter.OnDefenseUpgraded += Refresh;

            upgradeRoot.SetActive(true);
            upgradesList.SetDataSource(character.UpgradeData.Upgrades);
            Refresh();
        }

        private void BindUpgrade(
            Data.OnBind<DefenseUpgrade> evt,
            DefenseUpgradeVisuals target,
            int index)
        {
            if (selectedCharacter == null || evt.UserData == null)
                return;

            target.Bind(
                evt.UserData,
                selectedCharacter.GetUpgradeValue(evt.UserData.UpgradeType));
        }

        private void HandlePurchase(Gesture.OnClick evt)
        {
            if (selectedCharacter == null)
                return;

            selectedCharacter.TryUpgrade(currency);
            Refresh();
        }

        private void Refresh()
        {
            if (selectedCharacter == null)
                return;

            DefenseUpgradeData data = selectedCharacter.UpgradeData;
            defenseTitle.Text = data.DisplayName;
            defenseLevel.Text = $"Level {selectedCharacter.CurrentLevel}";

            if (data.Icon != null)
                defenseIcon.SetImage(data.Icon);
            else
                defenseIcon.ClearImage();

            bool eligible = selectedCharacter.CanUpgrade;
            bool affordable = currency.CurrentBalance >= data.Cost;
            upgradeButton.Color = eligible && affordable ? enabledButtonColor : Color.gray;

            if (selectedCharacter.HasUpgraded)
                upgradeButtonText.Text = "Upgraded";
            else if (!eligible)
                upgradeButtonText.Text = "Unavailable";
            else if (!affordable)
                upgradeButtonText.Text = $"Need {data.Cost} currency";
            else
                upgradeButtonText.Text = $"Upgrade ({data.Cost})";

            upgradesList.Refresh();
        }

        private void HandleSelectedCharacterDied(DefenseCharacterBase character)
        {
            ClearSelection();
        }

        private void HandleClose(Gesture.OnClick evt)
        {
            ClearSelection();
        }

        private void ClearSelection()
        {
            if (selectedCharacter != null)
            {
                selectedCharacter.Died -= HandleSelectedCharacterDied;
                selectedCharacter.OnDefenseUpgraded -= Refresh;
            }

            selectedCharacter = null;

            if (upgradesList != null)
                upgradesList.SetDataSource<DefenseUpgrade>(null);

            if (upgradeRoot != null)
                upgradeRoot.SetActive(false);
        }
    }
}
```

Do not add `selectedUpgrade`, `HandleUpgradeSelected`, or a row-click gesture handler. Currency notifications can briefly refresh the view during the purchase, but the completed upgrade event refreshes all three final stat values afterward. The visual button state is backed by validation in TryUpgrade; clicking again cannot charge twice.

## 6. Inspector assignments

Keep DefenseUpgradeController on your active manager object, not under DefenseUpgradeRoot. Otherwise hiding the panel also disables its character-selection listener.

| Controller field | Scene assignment |
| --- | --- |
| Currency | Active CurrencyManager |
| Hover Controller | Existing DefenseHoverController |
| Placement Manager | Existing DefensePlacementManager |
| Upgrade Root | DefenseUpgradeRoot GameObject |
| Upgrades List | DefenseUpgradeRoot/Background/UpgradesRoot ListView |
| Upgrade Button | Background/UpgradeButtonRoot/UpgradeButton UIBlock2D |
| Upgrade Button Text | UpgradeButton/UpgradeText TextBlock |
| Defense Title | HeaderRoot/HeadingTextRoot/DefenseTitleText TextBlock |
| Defense Level | HeaderRoot/HeadingTextRoot/DefenseLevelText TextBlock |
| Defense Icon | HeaderRoot/DefenseIcon/Icon UIBlock2D |
| Close Button | Optional close UIBlock with Nova Interactable |

In DefenseUpgrade.prefab's ItemView, select DefenseUpgradeVisuals and assign Background, UpgradeIcon, UpgradeNameText, CurrentAmountText, and NewAmountText to the matching fields. The row does not need a Nova Interactable. The separate purchase button does; it already has one in the saved scene.

Keep DefenseUpgrade.prefab registered in the UpgradesRoot ListView's Item Prefabs. The controller supplies three data entries; Nova creates/binds three rows.

Put the panel's actual background and UI elements, including dynamically created row prefab UIBlocks, on the UI layer used by DefenseHoverController.blockingUIMask. That prevents a purchase click from also selecting a character behind the panel. Do not make unrelated full-screen layout containers block the entire world.

Each defense prefab needs its UpgradeData asset assigned. Give each asset one Cost and exactly three distinct stat changes supported by that character. Example spear bundle: Cost 75, Damage becomes 8, Range becomes 16, AttackSpeed becomes 0.85 attacks/s. Starting values must be lower for each listed stat. Use the bomb's existing AOE overrides for an AOE entry.

## 7. Small CurrencyManager safeguard

You already added CurrentBalance and BalanceChanged, so the controller can use those directly.

At the start of PassiveIncome(), before accumulating time or dividing by passiveIncomeInterval, add:

```csharp
if (passiveIncomeInterval <= 0f || passiveIncomeAmount <= 0f)
    return;
```

Both fields can default to zero on a newly added component. This prevents dividing by zero while configuring the scene. The bundle validates its nonnegative cost before calling TrySpend.

## 8. Verification

1. Select a defense: see three previews and one bundle price. Clicking a preview must not select or purchase a stat.
2. Buy once: balance decreases by one Cost, all three stats change, level becomes 2, and the button says Upgraded.
3. Buy again: no currency or stats change.
4. Select another placed character of the same type: it still has its original stats and can buy its own bundle.
5. With insufficient funds: none of the stats change. When income arrives, affordability refreshes.
6. Configure a duplicate/unsupported stat or fewer than three entries: the purchase must be unavailable and charge nothing.
7. Verify Range reports its updated value, melee hits use updated reach, and upgraded attack animations still emit their throw/hit events.
8. Kill the selected character or begin placement: panel closes and subscriptions are removed.

Apply these edits together: the previous TryUpgrade(type, currency) API is replaced by TryUpgrade(currency). The proposed combined code has not been compiled or play-tested.
