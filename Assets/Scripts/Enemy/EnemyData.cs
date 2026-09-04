using Systems;
using UnityEngine;

namespace Enemy
{
    [CreateAssetMenu(menuName = "Entity/EnemyData")]
    public class EnemyData : EntityData
    {
        [SerializeField] private float maxHealth = 10f;
        [SerializeField] private int attackDamage = 1;
        [SerializeField] private float timeBetweenAttacks = 1f;
        [SerializeField] private float moveSpeed = 1f;
        [SerializeField] private float chanceToAttackDefenses = 0.5f;
        
        public float MaxHealth => maxHealth;
        public int AttackDamage => attackDamage;
        public float TimeBetweenAttacks => timeBetweenAttacks;
        public float MoveSpeed => moveSpeed;
        public float ChanceToAttackDefenses => chanceToAttackDefenses;
    }
}