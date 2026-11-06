using System;
using UnityEngine;

namespace Defenses.DefenseCharacters
{
    //All defense upgrade item types
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
    
    //Defense upgrade item
    [Serializable]
    public class DefenseUpgrade
    {
        [field: SerializeField] public DefenseUpgradeType UpgradeType { get; private set; }
        [field: SerializeField] public string UpgradeName { get; private set; }
        [field: SerializeField] public Sprite Icon { get; private set; }
        [field: SerializeField] public float UpgradedValue { get; private set; }    //New upgraded value
    }
    
    //Upgrade tier 
    [CreateAssetMenu(menuName = "Defenses/Defense Upgrade")]
    public class DefenseUpgradeData : ScriptableObject
    {
        [field: SerializeField] public string DefenseDisplayName { get; private set; }
        [field: SerializeField] public Sprite Icon { get; private set; }
        [field: SerializeField] public int Cost { get; private set; }

        //List of upgrade items
        [SerializeField] private DefenseUpgrade[] upgrades;
    
        public DefenseUpgrade[] Upgrades => upgrades;
    }
}