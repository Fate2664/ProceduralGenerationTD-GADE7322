using Defenses.DefenseCharacters;
using Nova;
using UnityEngine;

[System.Serializable]
public class DefenseUpgradeVisuals : ItemVisuals
{
    [SerializeField] private UIBlock2D Background;
    [SerializeField] private UIBlock2D UpgradeIcon;
    [SerializeField] private TextBlock UpgradeName;
    [SerializeField] private TextBlock CurrentAmount;
    [SerializeField] private TextBlock NewAmount;

    public void Bind(DefenseUpgrade upgrade, float currentValue)
    {
        UpgradeName.Text = upgrade.UpgradeName;
        CurrentAmount.Text = FormatValue(upgrade.UpgradeType, currentValue);
        NewAmount.Text = upgrade.UpgradedValue.ToString();
        UpgradeIcon.SetImage(upgrade.Icon);
    }
    
    private static string FormatValue(DefenseUpgradeType type, float value)
    {
        return type == DefenseUpgradeType.AttackSpeed
            ? $"{value:0.##}"
            : value.ToString("0.##");
    }
}
