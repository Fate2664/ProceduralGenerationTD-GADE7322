using UnityEngine;
using System;
using System.Collections;


public class WeatherManager : MonoBehaviour
{
    public static WeatherManager Instance;

    public static event Action<WeatherType> OnWeatherChanged;

    [SerializeField] ParticleSystem rainParticles;

    [SerializeField] int MaxDuration = 40;
    [SerializeField] int MinDuration = 20;
    private int duration;

    [Header("Multipliers")]
    public float enemySpeedMultiplier = 1f;
    public float enemyDamageMultiplier = 1f;
    public float towerRangeMultiplier = 1f;
    public float towerFireRateMultiplier = 1f;

    [Header("Visuals")]
    [SerializeField] private Light sun;
    [SerializeField] private WeatherLook[] looks;
    [SerializeField] private float transitionSpeed = 1f;

    private WeatherLook targetLook;

    private bool weatherActive = true;

    [System.Serializable]
    public class WeatherLook
    {
        public WeatherType weather;
        public float lightIntensity = 1f;
        public Color lightColor = Color.white;
        public Color ambientColor = Color.gray;
        public float fogDensity = 0f;
    }



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
        RenderSettings.fog = true;
        RenderSettings.fogMode = FogMode.Exponential;

        StartCoroutine(WeatherLoop());
    }

    private void Update()
    {
        if (targetLook == null) return;

        float t = transitionSpeed * Time.deltaTime;

        sun.intensity = Mathf.Lerp(sun.intensity, targetLook.lightIntensity, t);
        sun.color = Color.Lerp(sun.color, targetLook.lightColor, t);
        RenderSettings.ambientLight = Color.Lerp(RenderSettings.ambientLight, targetLook.ambientColor, t);
        RenderSettings.fogDensity = Mathf.Lerp(RenderSettings.fogDensity, targetLook.fogDensity, t);
    }
    private void SetTargetLook()
    {
        foreach (var look in looks)
        {
            if (look.weather == currentWeather)
            {
                targetLook = look;
                return;
            }
        }
    }

    
    private IEnumerator WeatherLoop()
    {
        while (weatherActive)
        {
            WeatherSelector();
            RandomiseDuration();
            ChangeStats();
            SetTargetLook();
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
