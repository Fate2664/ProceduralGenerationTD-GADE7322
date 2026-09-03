using System;
using System.Collections.Generic;
using PCG;
using Systems;
using UnityEngine;

public class Tower : MonoBehaviour, IDamageable
{
    [Header("Stats")] [SerializeField] private int health = 100;
    [SerializeField] private int attackDamage = 2;
    [SerializeField] private float timeBetweenAttacks = 1f;

    private WorldGenerator worldGenerator;
    private CountDownTimer attackTimer;
    private List<GridTile> surroundingTiles;

    private void Awake()
    {
        worldGenerator = GetComponentInParent<WorldGenerator>();
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
        
        DamageEnemiesOnSurroundingTiles();
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

    private void DamageEnemiesOnSurroundingTiles()
    {
        float halfTileSize = worldGenerator.GridOffset * .5f;

        foreach (var enemy in GameObject.FindGameObjectsWithTag("Enemy"))
        {
            foreach (GridTile tile in surroundingTiles)
            {
                Vector3 offset = enemy.transform.position - tile.transform.position;
                bool isOnTile = Mathf.Abs(offset.x) <= halfTileSize && Mathf.Abs(offset.z) <= halfTileSize;
                if (!isOnTile)
                    continue;
                
                if (enemy.TryGetComponent<IDamageable>(out IDamageable damageable))
                    damageable.TakeDamage(attackDamage);

                break;
            }
        }
    }

    public void TakeDamage(int attackDamage)
    {
        if (health <= 0)
        {
            Destroy(gameObject);
            Debug.Log("Tower has been destroyed");
        }
        else
        {
            health = health - attackDamage;
        }
    }
}