using System;
using UnityEngine;

public class Tower : MonoBehaviour, IDamageable
{
    [SerializeField] private int health = 100;
    
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