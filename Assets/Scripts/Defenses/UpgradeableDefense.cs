using System;
using Defenses.DefenseCharacters;
using Systems;

public abstract class UpgradeableDefense : Entity
{
    public abstract DefenseUpgradeData UpgradeData { get; }
    public abstract int CurrentLevel { get; }
    public abstract bool IsDead { get;  }

    public abstract event Action OnDefenseUpgraded;
    public event Action Unavailable;

    public abstract float GetUpgradeValue(DefenseUpgradeType type);
    public abstract bool TryUpgrade(CurrencyManager currency);

    protected void OnDestroy()
    {
        Unavailable?.Invoke();
    }
}