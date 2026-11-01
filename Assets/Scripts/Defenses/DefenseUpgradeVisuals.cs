using Defenses.DefenseCharacters;
using Nova;
using UnityEngine;

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
        CurrentAmount.Text = currentValue.ToString();
        NewAmount.Text = upgrade.UpgradedValue.ToString();
        UpgradeIcon.SetImage(upgrade.Icon);
    }
}
