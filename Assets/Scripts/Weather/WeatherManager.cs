using UnityEngine;
using System;
using Enemy;
using System.Collections;

public class WeatherManager : MonoBehaviour
{
    public static WeatherManager Instance;

    public static event Action<WeatherType> OnWeatherChanged;

    [SerializeField] ParticleSystem rainParticles;

    [SerializeField] int MaxDuration = 40;
    [SerializeField] int MinDuration = 20;
    private int duration;

    public float enemySpeedMultiplier = 1f;
    public float enemyDamageMultiplier = 1f;
    public float towerRangeMultiplier = 1f;
    public float towerFireRateMultiplier = 1f;

    private bool weatherActive = true;

    public enum WeatherType
    {
        Sunny,
        Rain,
        Fog,
        ThunderStorm
    }

    public WeatherType currentWeather;

    private void Awake()
    {
        Instance = this;
        rainParticles.Stop();
    }

    private void Start()
    {
        StartCoroutine(WeatherLoop());
    }

    private IEnumerator WeatherLoop()
    {
        while (weatherActive)
        {
            WeatherSelector();
            RandomiseDuration();
            ChangeStats();
            OnWeatherChanged?.Invoke(currentWeather);


            yield return new WaitForSeconds(duration);
        }
    }

    public void ChangeStats()
    {
        //Reset stats and visual effects
        enemySpeedMultiplier = 1f;
        enemyDamageMultiplier = 1f;
        towerRangeMultiplier = 1f;
        towerFireRateMultiplier = 1f;
        rainParticles.Stop();

        switch (currentWeather)
        {
            case WeatherType.Sunny:
                break;


            case WeatherType.Rain:
                rainParticles.Play();
                enemySpeedMultiplier = 0.8f;
                towerFireRateMultiplier = 0.9f; 
                break;

                case WeatherType.Fog:
                towerRangeMultiplier = 0.9f;
                break;

                case WeatherType.ThunderStorm:
                rainParticles.Play();
                enemySpeedMultiplier = 0.9f;
                enemyDamageMultiplier = 1.2f;
                break;
        }
           
    }

    public void WeatherSelector()
    {
        int count = Enum.GetValues(typeof(WeatherType)).Length;
        currentWeather = (WeatherType)UnityEngine.Random.Range(0, count);

    }

    public void RandomiseDuration()
    {
        int randomDuration = UnityEngine.Random.Range(MinDuration, MaxDuration + 1);

        duration = randomDuration; 
    }

}
