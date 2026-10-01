using Systems;
using UnityEngine;

namespace Enemy
{
    public enum EnemyType
    {
        Common, 
        Tank,
        Ranger,
        Swarmer
    }
    
    [CreateAssetMenu(menuName = "Entity/EnemyData")]
    public class EnemyData : EntityData
    {
        [SerializeField] private EnemyType type = EnemyType.Common;     //Role influences which routes suit this enemy
        [SerializeField] private float maxHealth = 10f;
        [SerializeField] private int attackDamage = 1;
        [SerializeField] private float timeBetweenAttacks = 1f;
        [SerializeField] private float moveSpeed = 1f;
        [SerializeField] private float chanceToAttackDefenses = 0.5f;

        [Header("Procedural Spawning")] 
        [SerializeField] private int threatCost = 1;    //How much of the wave budget this enemy consumes
        [SerializeField] private int unlockWave = 1;    //Earliest wave that it can spawn
        [SerializeField] private float selectionWeight = 1f;    //Relative likelihood of selection
        
        public float MaxHealth => maxHealth;
        public int AttackDamage => attackDamage;
        public float TimeBetweenAttacks => timeBetweenAttacks;
        public float MoveSpeed => moveSpeed;
        public float ChanceToAttackDefenses => chanceToAttackDefenses;
        public int ThreatCost => threatCost;
        public int UnlockWave => unlockWave;
        public float SelectionWeight => selectionWeight;
        public EnemyType Type => type;
    }
}