using System;

public abstract class DamageableDefense : UpgradeableDefense, IDamageable
{
    public event Action<DamageableDefense> DefenseDied;

    public abstract void TakeDamage(int attackDamage);

    protected void NotifyDefenseDied()
    {
        DefenseDied?.Invoke(this);
    }
}