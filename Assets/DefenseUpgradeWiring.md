# Wire the defense upgrade panel

> Superseded: the player buys one bundle containing all three stat changes. Do not implement the independent purchases or row-selection handlers below. Follow [DefenseUpgradeBundleWiring.md](../DefenseUpgradeBundleWiring.md) instead; it matches the renamed `DefenseUpgradeData` class and current `UpgradeType`, `UpgradedValue`, and `OnDefenseUpgraded` names.

This guide matches the current `DefenseUpgradeRoot` hierarchy and Nova APIs installed in this project. It is a proposed implementation: the game scripts, prefabs, and scene have not been changed by this guide.

## Behavior and ownership

Assumption: each defense type offers three different stat upgrades. Each option can be bought once per placed character, in any order. Buying Damage does not consume Range or MaxHealth. If you want multiple levels per option, use per-option purchase counts and tier arrays instead of the purchase set below.

The interaction is: select a character → select an upgrade row → press the existing UpgradeButton → validate and spend currency → update that character → refresh the panel.

- `DefenseUpradeData` stores shared definitions and the character's panel name/icon.
- `DefenseCharacterBase` owns purchased options and applies changes.
- `DefenseUpgradeVisuals` displays one row.
- `DefenseUpgradeController` owns selection, Nova binding, and panel visibility.
- `CurrencyManager` owns balance and reports changes.

All `NewValue` entries are absolute resulting values. Damage is an integer; Range and AOE are world-space radii; AttackSpeed is attacks per second; MaxHealth is maximum HP. Larger values are upgrades for every option.

## 1. Replace DefenseUpradeData.cs

Keep the existing filename and class spelling to preserve the asset script reference. This replaces sequential level bundles with independent options. Existing upgrade assets must be reconfigured after changing the fields.

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
        [field: SerializeField] public DefenseUpgradeType Type { get; private set; }
        [field: SerializeField] public string DisplayName { get; private set; }
        [field: SerializeField] public Sprite Icon { get; private set; }
        [field: SerializeField, Min(0)] public int Cost { get; private set; }
        [field: SerializeField, Min(0.01f)] public float NewValue { get; private set; }
    }

    [CreateAssetMenu(menuName = "Defenses/Defense Upgrades")]
    public class DefenseUpradeData : ScriptableObject
    {
        [field: SerializeField] public string DisplayName { get; private set; }
        [field: SerializeField] public Sprite Icon { get; private set; }

        [SerializeField] private DefenseUpgrade[] upgrades = Array.Empty<DefenseUpgrade>();

        public DefenseUpgrade[] Upgrades => upgrades;

        public DefenseUpgrade GetUpgrade(DefenseUpgradeType type)
        {
            foreach (DefenseUpgrade upgrade in upgrades)
            {
                if (upgrade != null && upgrade.Type == type)
                    return upgrade;
            }

            return null;
        }
    }
}
```

Configure exactly three entries with three distinct types in each asset. Only the bomb character supports AOE in the implementation below.

## 2. Update DefenseCharacterBase.cs

Add `using System.Collections.Generic;`.

Remove the `currentLevel` field, existing `CurrentLevel`, `MaxLevel`, and `NextUpgrade` properties, and the old `TryUpgrade(CurrencyManager currency)` method. Keep your damage/health fields, `upgradeData`, existing stat properties, and `OnDefenseLevelUpgraded` event.

Add these members inside the class:

```csharp
private readonly HashSet<DefenseUpgradeType> purchasedUpgrades = new();
private float initialAttackInterval;

private static readonly int AttackSpeedMultiplierId =
    Animator.StringToHash("AttackSpeedMultiplier");

public DefenseUpradeData UpgradeData => upgradeData;
public int CurrentLevel => 1 + purchasedUpgrades.Count;
public int MaxLevel => 1 + (upgradeData != null ? upgradeData.Upgrades.Length : 0);

public bool HasUpgrade(DefenseUpgradeType type) => purchasedUpgrades.Contains(type);

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

public bool CanUpgrade(DefenseUpgradeType type)
{
    if (IsDead || !isActiveAndEnabled || upgradeData == null || HasUpgrade(type))
        return false;

    DefenseUpgrade upgrade = upgradeData.GetUpgrade(type);

    if (upgrade == null || upgrade.Cost < 0 ||
        float.IsNaN(upgrade.NewValue) || float.IsInfinity(upgrade.NewValue))
        return false;

    float currentValue = GetUpgradeValue(type);

    if (currentValue < 0f || upgrade.NewValue <= currentValue)
        return false;

    if (type == DefenseUpgradeType.Damage &&
        upgrade.NewValue != Mathf.Round(upgrade.NewValue))
        return false;

    return true;
}

public bool TryUpgrade(DefenseUpgradeType type, CurrencyManager currency)
{
    if (currency == null || !CanUpgrade(type))
        return false;

    DefenseUpgrade upgrade = upgradeData.GetUpgrade(type);

    if (!currency.TrySpend(upgrade.Cost))
        return false;

    ApplyUpgradeValue(type, upgrade.NewValue);
    purchasedUpgrades.Add(type);
    OnDefenseLevelUpgraded?.Invoke();
    return true;
}

protected virtual void ApplyUpgradeValue(DefenseUpgradeType type, float value)
{
    switch (type)
    {
        case DefenseUpgradeType.Damage:
            attackDamage = Mathf.RoundToInt(value);
            break;
        case DefenseUpgradeType.Range:
            enemyDetector.SetDetectionRadius(value);
            break;
        case DefenseUpgradeType.AttackSpeed:
            timeBetweenAttacks = 1f / value;
            break;
        case DefenseUpgradeType.MaxHealth:
            currentHealth += value - maxHealth;
            maxHealth = value;
            currentHealth = Mathf.Clamp(currentHealth, 0f, maxHealth);
            healthBar?.SetHealth(currentHealth, maxHealth);
            break;
    }
}
```

In `Awake()`, immediately before constructing `attackTimer`, add:

```csharp
initialAttackInterval = timeBetweenAttacks;
```

Keep `timeBetweenAttacks` positive on all prefabs. Replace `Attack()` with:

```csharp
public virtual bool Attack()
{
    if (IsDead || attackTimer.IsRunning)
        return false;

    attackTimer.Reset(timeBetweenAttacks);
    attackTimer.Start();
    animator.SetFloat(AttackSpeedMultiplierId, initialAttackInterval / timeBetweenAttacks);
    PerformAttack();
    return true;
}
```

An attack-speed purchase changes the next attack's interval and animation multiplier. It does not restart the current cooldown or interrupt an attack in progress. `DefenseCharacterAttackState` can keep its existing call to `animator.Play(...)`.

Do not call `Initialize()` when upgrading. Purchase state belongs to the individual character, not the shared ScriptableObject.

### Required Animator setup

For the spear, melee, and bomb Animator Controllers:

1. Add a Float parameter named exactly `AttackSpeedMultiplier`, default `1`.
2. Select the `Attack` state.
3. Enable its Speed Multiplier parameter and choose `AttackSpeedMultiplier`.
4. Leave the Idle state's speed independent of that parameter.

Your current attack interval is intended to match the attack clip duration. Preserve that relationship in the base prefab values. The multiplier speeds up the attack clip and its release/hit events along with the cooldown.

## 3. Add range and AOE support

### EnemyDetector.cs

Add these members. Rebuilding the strategy matters because its radius values are copied into readonly fields when it is constructed.

```csharp
public float DetectionRadius => detectionRadius;

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

This retains the existing inner radius when increasing range. Detection angle is unchanged.

### MeleeDefenseCharacter.cs

Add these overrides so a melee Range upgrade changes both its actual hit reach and its detection radius:

```csharp
public override float GetUpgradeValue(DefenseUpgradeType type)
{
    return type == DefenseUpgradeType.Range
        ? meleeRange
        : base.GetUpgradeValue(type);
}

protected override void ApplyUpgradeValue(DefenseUpgradeType type, float value)
{
    if (type == DefenseUpgradeType.Range)
    {
        meleeRange = value;
        enemyDetector.SetDetectionRadius(value);
        return;
    }

    base.ApplyUpgradeValue(type, value);
}
```

For consistent initial behavior, set the melee prefab's detector radius to its base melee range and its inner detection radius no larger than that range.

### BombDefenseCharacter.cs

Add these overrides:

```csharp
public override float GetUpgradeValue(DefenseUpgradeType type)
{
    return type == DefenseUpgradeType.AOE
        ? bombAOERadius
        : base.GetUpgradeValue(type);
}

protected override void ApplyUpgradeValue(DefenseUpgradeType type, float value)
{
    if (type == DefenseUpgradeType.AOE)
    {
        bombAOERadius = value;
        return;
    }

    base.ApplyUpgradeValue(type, value);
}
```

No additional spear overrides are needed. Spear/bomb damage is already read when releasing the projectile; in-flight projectiles retain their original damage and radius.

## 4. Replace CurrencyManager.cs

Your scene's upgrade controller currently has no currency reference assigned. Assign it in step 7.

This version exposes the balance and an event for refreshing affordability. It also fixes the existing passive-income timer: `Time.time` is elapsed game time, and checking exact float equality can miss a payment.

```csharp
using System;
using UnityEngine;

public class CurrencyManager : MonoBehaviour
{
    [SerializeField] private float startingBalance;
    [SerializeField] private float passiveIncomeAmount;
    [SerializeField] private float passiveIncomeInterval;

    public static CurrencyManager Instance;

    private float currentBalance;
    private float timer;

    public float CurrentBalance => currentBalance;
    public event Action BalanceChanged;

    private void Awake()
    {
        Instance = this;
        currentBalance = Mathf.Max(0f, startingBalance);
    }

    private void Start()
    {
        BalanceChanged?.Invoke();
    }

    public void AddCurrency(float amount)
    {
        if (float.IsNaN(amount) || float.IsInfinity(amount) || amount < 0f)
            return;

        currentBalance += amount;
        BalanceChanged?.Invoke();
    }

    public bool TrySpend(float amount)
    {
        if (float.IsNaN(amount) || float.IsInfinity(amount) ||
            amount < 0f || currentBalance < amount)
            return false;

        currentBalance -= amount;
        BalanceChanged?.Invoke();
        return true;
    }

    private void Update()
    {
        if (passiveIncomeInterval <= 0f || passiveIncomeAmount <= 0f)
            return;

        timer += Time.deltaTime;

        if (timer < passiveIncomeInterval)
            return;

        int payments = Mathf.FloorToInt(timer / passiveIncomeInterval);
        timer -= payments * passiveIncomeInterval;
        AddCurrency(payments * passiveIncomeAmount);
    }
}
```

## 5. Replace DefenseUpgradeVisuals.cs

Keep this class in the global namespace. Your prefab's ItemView already references `DefenseUpgradeVisuals` in that namespace. Add `[Serializable]` so its fields can be serialized as Nova item visuals.

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

    [SerializeField] private Color availableColor = Color.white;
    [SerializeField] private Color selectedColor = new Color(1f, 0.85f, 0.35f);
    [SerializeField] private Color unavailableColor = Color.gray;

    public DefenseUpgrade BoundUpgrade { get; private set; }

    public void Bind(
        DefenseUpgrade upgrade,
        float currentValue,
        bool purchased,
        bool selected,
        bool canBuy)
    {
        BoundUpgrade = upgrade;

        string label = string.IsNullOrWhiteSpace(upgrade.DisplayName)
            ? upgrade.Type.ToString()
            : upgrade.DisplayName;

        UpgradeName.Text = $"{label} ({upgrade.Cost})";
        CurrentAmount.Text = currentValue < 0f ? "—" : FormatValue(upgrade.Type, currentValue);
        NewAmount.Text = purchased ? "Purchased" : FormatValue(upgrade.Type, upgrade.NewValue);
        Background.Color = selected ? selectedColor : canBuy ? availableColor : unavailableColor;

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

    public void Unbind()
    {
        BoundUpgrade = null;
    }
}
```

Costs are included in the name label because the row prefab currently has no dedicated cost label. You can add a separate cost TextBlock later without changing purchase logic.

## 6. Replace DefenseUpgradeController.cs

This follows your existing layout: a row selects an option, and the separate `UpgradeButton` buys it. It also updates the header and affordability when passive income arrives.

Keep this component on the existing active `Defenses` scene object, outside `DefenseUpgradeRoot`. Otherwise hiding the panel would disable the listener needed to reopen it.

```csharp
using System.Collections.Generic;
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
        [SerializeField] private UIBlock closeButton;
        [SerializeField] private TextBlock defenseTitle;
        [SerializeField] private TextBlock defenseLevel;
        [SerializeField] private UIBlock2D defenseIcon;

        private readonly List<DefenseUpgrade> options = new();
        private DefenseCharacterBase selectedCharacter;
        private DefenseUpgrade selectedUpgrade;
        private Color enabledButtonColor;

        private void Awake()
        {
            enabledButtonColor = upgradeButton.Color;

            upgradesList.AddDataBinder<DefenseUpgrade, DefenseUpgradeVisuals>(BindUpgrade);
            upgradesList.AddDataUnbinder<DefenseUpgrade, DefenseUpgradeVisuals>(UnbindUpgrade);
            upgradesList.AddGestureHandler<Gesture.OnClick, DefenseUpgradeVisuals>(HandleUpgradeSelected);
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
            selectedCharacter.OnDefenseLevelUpgraded += Refresh;

            foreach (DefenseUpgrade upgrade in character.UpgradeData.Upgrades)
            {
                if (upgrade != null)
                    options.Add(upgrade);
            }

            upgradeRoot.SetActive(true);
            upgradesList.SetDataSource(options);
            Refresh();
        }

        private bool CanBuy(DefenseUpgrade upgrade)
        {
            return selectedCharacter != null && upgrade != null &&
                selectedCharacter.CanUpgrade(upgrade.Type) &&
                currency.CurrentBalance >= upgrade.Cost;
        }

        private void BindUpgrade(
            Data.OnBind<DefenseUpgrade> evt,
            DefenseUpgradeVisuals target,
            int index)
        {
            if (selectedCharacter == null)
            {
                target.Unbind();
                return;
            }

            DefenseUpgrade upgrade = evt.UserData;
            target.Bind(
                upgrade,
                selectedCharacter.GetUpgradeValue(upgrade.Type),
                selectedCharacter.HasUpgrade(upgrade.Type),
                selectedUpgrade == upgrade,
                CanBuy(upgrade));
        }

        private void UnbindUpgrade(
            Data.OnUnbind<DefenseUpgrade> evt,
            DefenseUpgradeVisuals target,
            int index)
        {
            target.Unbind();
        }

        private void HandleUpgradeSelected(
            Gesture.OnClick evt,
            DefenseUpgradeVisuals target,
            int index)
        {
            if (selectedCharacter == null || target.BoundUpgrade == null)
                return;

            selectedUpgrade = target.BoundUpgrade;
            Refresh();
        }

        private void HandlePurchase(Gesture.OnClick evt)
        {
            if (CanBuy(selectedUpgrade))
                selectedCharacter.TryUpgrade(selectedUpgrade.Type, currency);

            Refresh();
        }

        private void Refresh()
        {
            if (selectedCharacter == null)
                return;

            defenseTitle.Text = selectedCharacter.UpgradeData.DisplayName;
            defenseLevel.Text = $"Level {selectedCharacter.CurrentLevel}/{selectedCharacter.MaxLevel}";

            Sprite icon = selectedCharacter.UpgradeData.Icon;
            if (icon != null)
                defenseIcon.SetImage(icon);
            else
                defenseIcon.ClearImage();

            bool canBuy = CanBuy(selectedUpgrade);
            upgradeButton.Color = canBuy ? enabledButtonColor : Color.gray;

            if (selectedUpgrade == null)
                upgradeButtonText.Text = "Select an upgrade";
            else if (selectedCharacter.HasUpgrade(selectedUpgrade.Type))
                upgradeButtonText.Text = "Purchased";
            else if (!selectedCharacter.CanUpgrade(selectedUpgrade.Type))
                upgradeButtonText.Text = "Unavailable";
            else
                upgradeButtonText.Text = canBuy
                    ? $"Upgrade ({selectedUpgrade.Cost})"
                    : $"Need {selectedUpgrade.Cost} currency";

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
                selectedCharacter.OnDefenseLevelUpgraded -= Refresh;
            }

            selectedCharacter = null;
            selectedUpgrade = null;
            options.Clear();

            if (upgradesList != null)
                upgradesList.SetDataSource<DefenseUpgrade>(null);

            if (upgradeRoot != null)
                upgradeRoot.SetActive(false);
        }
    }
}
```

Handlers on this component's own UI references are registered once in `Awake()`. External character, currency, and hover subscriptions are removed when deselecting or disabling. The purchase button is visually unavailable when a purchase cannot succeed; its click handler also rechecks the real character state and balance.

## 7. Inspector wiring

### DefenseUpgrade.prefab

Your current ItemView has the correct visuals type, but its serialized visuals data is empty. After the new `[Serializable]` class compiles, select its root ItemView and assign:

| Visuals field | Existing prefab object/component |
| --- | --- |
| Background | Root DefenseUpgrade UIBlock2D |
| UpgradeIcon | UpgradeIcon UIBlock2D |
| UpgradeName | UpgradeNameText TextBlock |
| CurrentAmount | CurrentAmountText TextBlock |
| NewAmount | NewAmountText TextBlock |

Add a **Nova Interactable** to the row root if it is absent. The current saved prefab has an ItemView but no Interactable. Keep row dragging disabled.

Set the prefab's UI objects to the **UI** GameObject layer, including its root and child UIBlocks.

### MainLevel / DefenseUpgradeRoot

Your panel already contains:

```text
DefenseUpgradeRoot
  Background
    HeaderRoot
      DefenseIcon
        Icon
      HeadingTextRoot
        DefenseLevelText
        DefenseTitleText
    UpgradeButtonRoot
      UpgradeButton
        UpgradeText
    UpgradesRoot
```

The `UpgradesRoot` ListView already references the `DefenseUpgrade` ItemView prefab. Keep that registration; the controller supplies its data source at runtime.

Assign these fields on the scene's DefenseUpgradeController:

| Controller field | Assignment |
| --- | --- |
| Currency | The active scene CurrencyManager; currently unassigned |
| Hover Controller | Existing DefenseHoverController |
| Placement Manager | Existing DefensePlacementManager |
| Upgrade Root | DefenseUpgradeRoot GameObject |
| Upgrades List | Background/UpgradesRoot ListView |
| Upgrade Button | Background/UpgradeButtonRoot/UpgradeButton UIBlock2D |
| Upgrade Button Text | UpgradeButton/UpgradeText TextBlock |
| Defense Title | HeaderRoot/HeadingTextRoot/DefenseTitleText TextBlock |
| Defense Level | HeaderRoot/HeadingTextRoot/DefenseLevelText TextBlock |
| Defense Icon | HeaderRoot/DefenseIcon/Icon UIBlock2D |
| Close Button | Optional new close UIBlock with a Nova Interactable |

The existing UpgradeButton already has a Nova Interactable. Add a close button if you want explicit dismissal; its field is optional. Starting placement or the selected character dying also closes the panel.

Set this panel's UIBlocks, background, buttons, and texts to the **UI** GameObject layer. Your hover controller's blocking mask contains UI, but the new panel is currently saved on Default. Without this change, clicking a row can also select a character behind the panel.

Do not put the full-screen gameplay UI layout root on the blocking layer merely to configure this panel; only the panel's actual area should block world picking.

### Assets and character prefabs

Create one Defense Upgrades asset per defense type. Set its panel DisplayName and Icon, then configure three distinct options. Assign that asset to the defense prefab's existing Upgrade Data field.

For example, using the spear prefab's currently saved base values:

| Spear option | Cost example | Base value | NewValue example |
| --- | ---: | ---: | ---: |
| Damage | 25 | 5 | 8 |
| Range | 30 | 13 | 16 |
| AttackSpeed | 40 | approximately 0.68/s | 0.85 |

For melee you could choose Damage, MaxHealth, and AttackSpeed. For bombs, Damage, Range, and AOE. These are configuration choices; the code supports the valid enum options rather than hardcoding three combinations.

Every NewValue must exceed that stat's base value. Damage values must be whole numbers. Configure positive base attack intervals and positive health/ranges. With three one-time options, character level runs from 1 to 4; the header counts purchased options, not sequential stat tiers.

## 8. Verify in Play Mode

1. Place two spear ants. Select one: its name, icon, level, and three rows should appear.
2. Select Damage: the row highlights; the separate button displays its price. Selecting a row must not spend currency.
3. Buy it: balance drops once, damage changes, the row says Purchased, and the other ant remains unchanged.
4. Click Buy again: no further charge or stat change.
5. Buy another option: it remains independently available after Damage.
6. With insufficient currency, no purchase occurs. Add currency or wait for passive income: affordability updates without reopening the panel.
7. Buy AttackSpeed during a throw: the current throw completes; subsequent throws use the faster animation and cooldown.
8. Buy Range: enemies in the newly added range become detectable. For melee, verify actual hits reach the upgraded distance.
9. Buy MaxHealth on an injured character: preserve damage already taken. For example, 4/8 becomes 8/12, not 12/12.
10. Switch characters, kill the selected character, or begin placement: the panel must not retain the old target.
11. Click the panel over a character in the world: selection must remain unchanged.

The suggested code has been matched to the current repository and locally installed Nova API signatures, but has not been compiled or run as a combined implementation. Apply the code changes together before testing; the old sequential-upgrade API is intentionally replaced.
