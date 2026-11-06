using System;
using Enemy;
using UnityEngine;

//Weather profile to hold the weather type's data
[Serializable]
public class WeatherWaveProfile
{
    [SerializeField] private WeatherType weather;
    [SerializeField] private int firstWave = 1; //First wave that this weather can have the possibility to appear

    //Enemy weights for this weather type
    [Header("Enemy Selection Mulipliers")] 
    [SerializeField] private float commonWeight = 1f;
    [SerializeField] private float rangerWeight = 1f;
    [SerializeField] private float swarmerWeight = 1f;
    
    
    public WeatherType Weather => weather;
    public int FirstWave => firstWave;

    public WeatherWaveProfile(WeatherType weather, int firstWave, float commonWeight = 1f,
        float rangerWeight = 1f, float swarmerWeight = 1f)
    {
        this.weather = weather;
        this.firstWave = firstWave;
        this.commonWeight = commonWeight;
        this.rangerWeight = rangerWeight;
        this.swarmerWeight = swarmerWeight;
    }

    //Supporting method to get an enemy's weight for this weather profile
    public float GetEnemyWeight(EnemyType enemyType)
    {
        float weight = enemyType switch
        {
            EnemyType.Common => commonWeight,
            EnemyType.Ranger => rangerWeight,
            EnemyType.Swarmer => swarmerWeight,
            _ => 1f
        };
        return weight;
    }
}