using UnityEngine;
using System;
using Enemy;

public class WeatherManager : MonoBehaviour
{
    public static WeatherManager Instance; 

    [SerializeField] int MaxDuration = 40;
    [SerializeField] int MinDuration = 20;
    private int duration;

    private EnemyData[] enemyData;

    public float enemySpeedMultiplier = 1f;
    public float enemyDamageMultiplier = 1f;
    public float towerRangeMultiplier = 1f;
    public float towerFireRateMultiplier = 1f;



    public enum WeatherType
    {
        Sunny,
        Rain,
        Fog,
        ThunderStorm
    }

    
    private WeatherType weatherType;

    private void Awake()
    {
        Instance = this;
    }

    public void ChangeStats()
    {
        switch (weatherType)
        {
            case WeatherType.Sunny:
                break;


            case WeatherType.Rain:
                enemySpeedMultiplier = 0.8f;
                towerFireRateMultiplier = 0.9f; 
                break;

                case WeatherType.Fog:
                towerRangeMultiplier = 0.9f;
                break;

                case WeatherType.ThunderStorm:
                enemySpeedMultiplier = 0.9f;
                enemyDamageMultiplier = 1.2f;
                break;
        }
           
    }

    public void WeatherSelector()
    {
       int randomCount = Enum.GetValues(typeof(WeatherType)).Length;
       int randomIndex = UnityEngine.Random.Range(0, randomCount);

       weatherType = (WeatherType)randomIndex;

    }

    public void RandomiseDuration()
    {
        int randomDuration = UnityEngine.Random.Range(MinDuration, MaxDuration + 1);

        duration = randomDuration; 
    }

}
