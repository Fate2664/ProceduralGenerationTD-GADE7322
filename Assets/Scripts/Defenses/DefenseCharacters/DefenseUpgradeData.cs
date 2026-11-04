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
        AOE,
        CurrencyProductionAmount,
        CurrencyProductionSpeed
    }
    
    [Serializable]
    public class DefenseUpgrade
    {
        [field: SerializeField] public DefenseUpgradeType UpgradeType { get; private set; }
        [field: SerializeField] public string UpgradeName { get; private set; }
        [field: SerializeField] public Sprite Icon { get; private set; }
        [field: SerializeField] public float UpgradedValue { get; private set; }
    }
    
    [CreateAssetMenu(menuName = "Defenses/Defense Upgrade")]
    public class DefenseUpgradeData : ScriptableObject
    {
        [field: SerializeField] public string DefenseDisplayName { get; private set; }
        [field: SerializeField] public Sprite Icon { get; private set; }
        [field: SerializeField] public int Cost { get; private set; }

        [SerializeField] private DefenseUpgrade[] upgrades;
    
        public DefenseUpgrade[] Upgrades => upgrades;
    }
}