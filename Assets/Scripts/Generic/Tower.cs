using System;
using UnityEngine;

public class Tower : MonoBehaviour, IDamageable
{
    [SerializeField] private int health = 100;
    
    public void TakeDamage(int attackDamage)
    {
        if (health <= 0)
            Debug.Log("Tower is dead");
        else
        {
            health = health - attackDamage;
        }
        
    }
}