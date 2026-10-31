using System;
using UnityEngine;

namespace Defenses.DefenseCharacters
{
    [Serializable]
    public class DefenseUpgradeLevel
    {
        [field: SerializeField] public int Cost { get; private set; }
        [field: SerializeField] public int AttackDamage { get; private set; }
        [field: SerializeField] public int MaxHealth { get; private set; }
    }
    
    [CreateAssetMenu(menuName = "Defenses/Defense Upgrades")]
    public class DefenseUpradeData : ScriptableObject
    {
        [SerializeField] private DefenseUpgradeLevel[] upgradeLevels;
        public int MaxLevel => upgradeLevels.Length;

        public DefenseUpgradeLevel GetNextUpgrade(int currentLevel)
        {
            int upgradeIndex = currentLevel - 1;
            return upgradeLevels[upgradeIndex];
        }
    }
}