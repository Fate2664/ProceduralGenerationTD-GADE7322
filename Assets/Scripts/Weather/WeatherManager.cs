using Defenses.DefenseCharacters;
using Enemy;
using System;
using System.Collections;
using System.Collections.Generic;
using DG.Tweening;
using PCG;
using UnityEngine;

//All weather types
public enum WeatherType
{
    Sunny,
    Rain,
    Fog,
    ThunderStorm
}


public class WeatherManager : MonoBehaviour
{
    [SerializeField] ParticleSystem rainParticles;
    [SerializeField] int MaxDuration = 40;
    [SerializeField] int MinDuration = 20;

    //Negative effects the weather has on defence characters
    [Header("Weather Effects")]
    [SerializeField, Range(0.1f, 1f)] private float wetDefenseDamageMultiplier = 0.9f;  //Wet weather reduces damage dealt
    [SerializeField, Range(0.1f, 1f)] private float fogDefenseAttackSpeedMultiplier = 0.85f;    //Fog reduces attack speed

    //Weather profiles for all weather types with thier enemy weights
    [Header("Weather Wave Profiles")] 
    [SerializeField] private WeatherWaveProfile[] waveProfiles =
    {
        new(WeatherType.Sunny, 1),
        new(WeatherType.Rain, 4, commonWeight: 1.2f, swarmerWeight: 0.8f),
        new(WeatherType.ThunderStorm, 6, rangerWeight: 1.3f, swarmerWeight: 0.7f),
        new(WeatherType.Fog, 8, commonWeight: 0.8f, rangerWeight: 1.1f, swarmerWeight: 1.3f)
    };

    [Header("Visuals")] 
    [SerializeField] private Light sun;
    [SerializeField] private WeatherLook[] looks;
    [SerializeField] private float transitionSpeed = 1f;

    [Header("Clouds")] 
    [SerializeField] private WorldGenerator worldGenerator;
    [SerializeField] private Renderer weatherCloudRenderer;
    [SerializeField] private float cloudFormationDuration = 6f;

    [Header("Fog Clouds")] 
    [SerializeField] private float fogCloudWorldY = 35f;
    [SerializeField, Range(0.05f, 1f)] private float fogClearSize = 0.5f;
    [SerializeField] private float fogExlusionFeather = 5f;
    [SerializeField] private float fogTransitionDuration = 4f;

    [Header("Lightning")] 
    [SerializeField] float minLightningInterval = 3f;
    [SerializeField] float maxLightningInterval = 8f;
    [SerializeField] int lightningDamage = 5;
    [SerializeField] private float flashIntensity = 3f;
    [SerializeField] private float flashDuration = 0.08f;
    [SerializeField] private Lightning lightningBoltPrefab;

    //Enemy 
    [HideInInspector] public float currEnemySpeedMult = 1f;
    [HideInInspector] public float currEnemyDamageMult = 1f;
    
    //These are unused
    [HideInInspector] public float currTowerRangeMult = 1f;
    [HideInInspector] public float currTowerFireRateMult = 1f;
    
    private int duration;
    private int currentWave;
    private Coroutine lightningRoutine;
    private WeatherLook targetLook;
    private bool weatherActive = true;
    private Material weatherCloudMaterial;
    private Tween cloudCoverageTween;
    private float targetCloudCoverage;
    private float normalCloudWorldY;
    private Tween cloudHeightTween;
    private Tween cloudExclusionTween;
    private Tween cloudNoiseHeightTween;
    private static readonly int CloudExclusionBoundsId = Shader.PropertyToID("_CloudExclusionBounds");
    private static readonly int CloudExclusionEnabledId = Shader.PropertyToID("_CloudExclusionEnabled");
    private static readonly int CloudExclusionFeatherId = Shader.PropertyToID("_CloudExclusionFeather");
    private readonly List<WeatherType> eligibleWeather = new();
    private readonly List<DamageableDefense> lightningTargets = new();

    public static WeatherManager Instance;
    public float DefenseDamageMultiplier { get; private set; }
    public float DefenseAttackSpeedMultiplier { get; private set; }
    public WeatherType currentWeather;
    public static event Action<WeatherType> OnWeatherChanged;
    public void SetWaveNumber(int waveNumber) => currentWave = waveNumber;

    [System.Serializable]
    public class WeatherLook
    {
        public WeatherType weather;
        public float lightIntensity = 1f;
        public Color lightColor = Color.white;
        public Color ambientColor = Color.gray;
        public float fogDensity = 0f;
    }

    private void Awake()
    {
        Instance = this;
        currentWeather = WeatherType.Sunny;
        rainParticles.Stop();
    }

    private void Start()
    {
        RenderSettings.fog = true;
        RenderSettings.fogMode = FogMode.Exponential;

        if (weatherCloudRenderer != null)
        {
            normalCloudWorldY = weatherCloudRenderer.transform.position.y;

            weatherCloudMaterial = weatherCloudRenderer.material;
            weatherCloudMaterial.SetFloat("_CloudCoverage", 0f);
            weatherCloudMaterial.SetFloat(CloudExclusionEnabledId, 0f);

            UpdateFogExclusionBounds();
        }

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

    private void LateUpdate()
    {
        UpdateFogExclusionBounds();
    }
    
    //Change the visuals based on the current weather
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

    //This is the weather loop method that is played throughout the game
    private IEnumerator WeatherLoop()
    {
        while (weatherActive)
        {
            //First randomize the duraction of the weather
            RandomiseDuration();
            //Update the defense character stats based on the weather type
            ChangeStats();
            //Update the visual look based on the weather type
            SetTargetLook();
            OnWeatherChanged?.Invoke(currentWeather);
            
            //Wait for the weather duration to end
            yield return new WaitForSeconds(duration);
            
            //Select new weather
            WeatherSelector();
        }
    }
    
    //This method applies the debuffs to the defense characters when it is not sunny
    public void ChangeStats()
    {
        //Reset stats and visual effects
        currEnemySpeedMult = 1f;
        currEnemyDamageMult = 1f;
        currTowerRangeMult = 1f;
        currTowerFireRateMult = 1f;
        DefenseDamageMultiplier = 1f;
        DefenseAttackSpeedMultiplier = 1f;
        
        rainParticles.Stop();
        StopLightning();

        switch (currentWeather)
        {
            case WeatherType.Rain:
                rainParticles.Play();
                DefenseDamageMultiplier = wetDefenseDamageMultiplier;
                break;

            case WeatherType.Fog:
                DefenseAttackSpeedMultiplier = fogDefenseAttackSpeedMultiplier;
                break;

            case WeatherType.ThunderStorm:
                rainParticles.Play();
                DefenseDamageMultiplier = wetDefenseDamageMultiplier;
                StartLightning();
                break;
        }

        UpdateFogCloudState();
        UpdateCloudCoverage();
    }

    public WeatherWaveProfile GetCurrentWaveProfile()
    {
        foreach (var profile in waveProfiles)
        {
            if (profile.Weather == currentWeather)
                return profile;
        }
        return null;
    }

    //This method selects what weather will occur based on the current wave and a random choice
    public void WeatherSelector()
    {
        eligibleWeather.Clear();
        eligibleWeather.Add(WeatherType.Sunny);

        foreach (var profile in waveProfiles)
        {
            //If the current wave is before the first wave that this weather type can occur
            if (currentWave < profile.FirstWave)
                continue;
            
            if (!eligibleWeather.Contains(profile.Weather))
                eligibleWeather.Add(profile.Weather);
        }
        
        //Randomly select weather from eligble options
        int selectedIndex = UnityEngine.Random.Range(0, eligibleWeather.Count);
        currentWeather = eligibleWeather[selectedIndex];
    }

    //Randomize the duration of the weather
    public void RandomiseDuration()
    {
        int randomDuration = UnityEngine.Random.Range(MinDuration, MaxDuration + 1);
        duration = randomDuration;
    }


    #region Lightning

    private IEnumerator LightningLoop()
    {
        while (currentWeather == WeatherType.ThunderStorm)
        {
            yield return new WaitForSeconds(UnityEngine.Random.Range(minLightningInterval, maxLightningInterval));
            StrikeLightning();
        }
    }

    private void StrikeLightning()
    {
        if (currentWeather != WeatherType.ThunderStorm)
            return;

        lightningTargets.Clear();

        foreach (var tile in worldGenerator.Grid)
        {
            if (tile.Occupant == null)
                continue;
            if (!tile.Occupant.TryGetComponent(out DamageableDefense defense))
                continue;
            if (defense.IsDead)
                continue;
            
            lightningTargets.Add(defense);
        }

        if (lightningTargets.Count == 0)
            return;
        
        int targetIndex = UnityEngine.Random.Range(0, lightningTargets.Count);
        DamageableDefense target = lightningTargets[targetIndex];
        Vector3 strikePosition = target.transform.position;

        Lightning bolt = Instantiate(lightningBoltPrefab);
        bolt.Strike(strikePosition);
        target.TakeDamage(lightningDamage);
        StartCoroutine(Flash());
    }
    
    private IEnumerator Flash()
    {
        sun.intensity = flashIntensity;
        yield return new WaitForSeconds(flashDuration);
        sun.intensity = targetLook != null ? targetLook.lightIntensity : 1f;
    }

    private void StartLightning()
    {
        StopLightning();
        lightningRoutine = StartCoroutine(LightningLoop());
    }

    private void StopLightning()
    {
        if (lightningRoutine != null)
        {
            StopCoroutine(lightningRoutine);
            lightningRoutine = null;
        }
    }

    #endregion
    
    #region Clouds

    private void UpdateCloudCoverage()
    {
        if (weatherCloudMaterial == null)
            return;

        bool needsClouds = currentWeather == WeatherType.Rain || currentWeather == WeatherType.ThunderStorm ||
                           currentWeather == WeatherType.Fog;
        float target = needsClouds ? 1f : 0f;

        if (cloudCoverageTween != null && Mathf.Approximately(targetCloudCoverage, target))
            return;

        cloudCoverageTween?.Kill();
        cloudCoverageTween = null;
        targetCloudCoverage = target;

        float current = weatherCloudMaterial.GetFloat("_CloudCoverage");

        if (Mathf.Approximately(current, target))
        {
            weatherCloudMaterial.SetFloat("_CloudCoverage", target);
            return;
        }

        float duration = cloudFormationDuration * Mathf.Abs(target - current);
        cloudCoverageTween = weatherCloudMaterial.DOFloat(target, "_CloudCoverage", duration).SetEase(Ease.InOutSine)
            .SetAutoKill(true).OnKill(() => cloudCoverageTween = null);
    }

    private void UpdateFogExclusionBounds()
    {
        Vector3 center = worldGenerator.transform.position;
        float halfExtent = worldGenerator.GridSize * worldGenerator.GridOffset * fogClearSize * 0.5f;
        weatherCloudMaterial.SetVector(CloudExclusionBoundsId, new Vector4(center.x, center.z, halfExtent, halfExtent));
        weatherCloudMaterial.SetFloat(CloudExclusionFeatherId, fogExlusionFeather);
    }

    private void UpdateFogCloudState()
    {
        bool isFog = currentWeather == WeatherType.Fog;
        weatherCloudMaterial.SetFloat("_Noise_Height", isFog ? 3f : 30f);
        float targetHeight = isFog ? fogCloudWorldY : normalCloudWorldY;
        float exlcusionStrength = isFog ? 1f : 0f;
        cloudHeightTween?.Kill();
        cloudExclusionTween?.Kill();
        cloudNoiseHeightTween?.Kill();

        cloudHeightTween = weatherCloudRenderer.transform.DOMoveY(targetHeight, fogTransitionDuration)
            .SetEase(Ease.InOutSine).SetAutoKill(true).OnKill(() => cloudHeightTween = null);
        cloudExclusionTween = weatherCloudMaterial
            .DOFloat(exlcusionStrength, CloudExclusionEnabledId, fogTransitionDuration).SetEase(Ease.InOutSine)
            .SetAutoKill(true).OnKill(() => cloudExclusionTween = null);
        cloudNoiseHeightTween = weatherCloudMaterial.DOFloat(isFog ? 3f : 30f, "_Noise_Height", fogTransitionDuration)
            .SetEase(Ease.InOutSine).SetAutoKill(true).OnKill(() => cloudNoiseHeightTween = null);
    }

    #endregion

    private void OnDisable()
    {
        cloudCoverageTween?.Kill();
        cloudHeightTween?.Kill();
        cloudExclusionTween?.Kill();
        cloudNoiseHeightTween?.Kill();

        cloudCoverageTween = null;
        cloudNoiseHeightTween = null;
        cloudHeightTween = null;
        cloudExclusionTween = null;
    }

    private void OnDestroy()
    {
        cloudCoverageTween?.Kill();
        cloudHeightTween?.Kill();
        cloudExclusionTween?.Kill();
        Destroy(weatherCloudMaterial);
    }

}