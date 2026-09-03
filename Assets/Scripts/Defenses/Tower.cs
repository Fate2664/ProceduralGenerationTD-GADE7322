using System;
using System.Collections.Generic;
using PCG;
using Systems;
using UnityEngine;

public class Tower : MonoBehaviour, IDamageable
{
    [Header("Stats")] 
    [SerializeField] private int health = 100;
    [SerializeField] private int attackDamage = 2;
    [SerializeField] private float timeBetweenAttacks = 1f;

    private WorldGenerator worldGenerator;
    private CountDownTimer attackTimer;
    private List<GridTile> surroundingTiles;
    private Animator animator;
    private static readonly int AttackTrigger = Animator.StringToHash("Attack");
    
    private void Awake()
    {
        worldGenerator = GetComponentInParent<WorldGenerator>();
        animator = GetComponentInChildren<Animator>();
        attackTimer = new CountDownTimer(timeBetweenAttacks);
    }

    private void Start()
    {
        surroundingTiles = GetSurroundingTiles();
    }

    private void Update()
    {
        attackTimer.Tick(Time.deltaTime);

        if (attackTimer.IsRunning)
            return;

        if (AttackEnemiesOnSurroundingTiles())
        {
            animator.SetTrigger(AttackTrigger);
        }
        
        attackTimer.Start();
    }   

    private List<GridTile> GetSurroundingTiles()
    {
        int centerX = worldGenerator.Grid.GetLength(0) / 2;
        int centerZ = worldGenerator.Grid.GetLength(1) / 2;

        return new List<GridTile>
        {
            //Left
            worldGenerator.Grid[centerX - 1, centerZ],
            //Right
            worldGenerator.Grid[centerX + 1, centerZ],
            //Top
            worldGenerator.Grid[centerX, centerZ - 1],
            //Bottom
            worldGenerator.Grid[centerX, centerZ + 1]
        };

    }

    private bool AttackEnemiesOnSurroundingTiles()
    {
        float halfTileSize = worldGenerator.GridOffset * .5f;
        bool attackedEnemy = false;

        foreach (var enemy in GameObject.FindGameObjectsWithTag("Enemy"))
        {
            foreach (GridTile tile in surroundingTiles)
            {
                Vector3 offset = enemy.transform.position - tile.transform.position;
                bool isOnTile = Mathf.Abs(offset.x) <= halfTileSize && Mathf.Abs(offset.z) <= halfTileSize;
                if (!isOnTile)
                    continue;

                if (enemy.TryGetComponent<IDamageable>(out IDamageable damageable))
                {
                    damageable.TakeDamage(attackDamage);
                    attackedEnemy = true;
                }

                break;
            }
        }

        return attackedEnemy;
    }

    public void TakeDamage(int attackDamage)
    {
        health -= attackDamage;

        if (health <= 0)
        {
            Destroy(gameObject);
            Debug.Log("Tower has been destroyed");
        }
    }
}