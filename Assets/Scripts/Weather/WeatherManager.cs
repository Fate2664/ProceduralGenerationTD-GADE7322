using Defenses.DefenseCharacters;
using Enemy;
using System;
using System.Collections;
using DG.Tweening;
using PCG;
using UnityEngine;


public class WeatherManager : MonoBehaviour
{
    [SerializeField] ParticleSystem rainParticles;
    [SerializeField] int MaxDuration = 40;
    [SerializeField] int MinDuration = 20;

    [Header("Multipliers")] public float enemySpeedMult = 0.8f;
    public float enemyDamageMult = 1f;
    public float towerRangeMult = 0.9f;
    public float towerFireRateMult = 0.7f;

    [HideInInspector] public float currEnemySpeedMult = 1f;
    [HideInInspector] public float currEnemyDamageMult = 1f;
    [HideInInspector] public float currTowerRangeMult = 1f;
    [HideInInspector] public float currTowerFireRateMult = 1f;

    [Header("Visuals")] [SerializeField] private Light sun;
    [SerializeField] private WeatherLook[] looks;
    [SerializeField] private float transitionSpeed = 1f;

    [Header("Clouds")] [SerializeField] private WorldGenerator worldGenerator;
    [SerializeField] private float cloudExclusionPadding = 2f;
    [SerializeField] private Renderer weatherCloudRenderer;
    [SerializeField] private float cloudFormationDuration = 6f;

    [Header("Lightning")] [SerializeField] float minLightningInterval = 3f;
    [SerializeField] float maxLightningInterval = 8f;
    [SerializeField] int lightningDamage = 5;
    [Range(0f, 1f)] [SerializeField] private float chanceToHitDefense = 0.2f;
    [SerializeField] GameObject lightningObject;
    [SerializeField] private float flashIntensity = 3f;
    [SerializeField] private float flashDuration = 0.08f;
    [SerializeField] private Lightning lightningBoltPrefab;

    private int duration;
    private Coroutine lightningRoutine;
    private WeatherLook targetLook;
    private bool weatherActive = true;
    private Material weatherCloudMaterial;
    private Tween cloudCoverageTween;
    private float targetCloudCoverage;
    private static readonly int CloudExclusionBoundsId = Shader.PropertyToID("_CloudExclusionBounds");
    private static readonly int CloudExclusionEnabledId = Shader.PropertyToID("_CloudExclusionEnabled");

    public static WeatherManager Instance;
    public static event Action<WeatherType> OnWeatherChanged;
    public WeatherType currentWeather;

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

    private void Awake()
    {
        Instance = this;
        rainParticles.Stop();
    }

    private void Start()
    {
        RenderSettings.fog = true;
        RenderSettings.fogMode = FogMode.Exponential;

        if (weatherCloudRenderer != null)
        {
            weatherCloudMaterial = weatherCloudRenderer.material;
            weatherCloudMaterial.SetFloat("_CloudCoverage", 0f);
        }

        StartCoroutine(WeatherLoop());
    }

    private IEnumerator Flash()
    {
        sun.intensity = flashIntensity;
        yield return new WaitForSeconds(flashDuration);
        sun.intensity = targetLook != null ? targetLook.lightIntensity : 1f;
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
        if (!worldGenerator.IsGenerated)
        {
            Shader.SetGlobalFloat(CloudExclusionEnabledId, 0f);
            return;
        }

        Vector3 center = worldGenerator.transform.position;
        float halfExtent = worldGenerator.GridSize * worldGenerator.GridOffset * 0.5f + cloudExclusionPadding;

        Shader.SetGlobalVector(CloudExclusionBoundsId, new Vector4(center.x, center.z, halfExtent, halfExtent));
        Shader.SetGlobalFloat(CloudExclusionEnabledId, 1f);
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
        EnemyBase.All.RemoveAll(e => e == null);
        DefenseCharacterBase.All.RemoveAll(d => d == null);

        bool hasEnemies = EnemyBase.All.Count > 0;
        bool hasDefenses = DefenseCharacterBase.All.Count > 0;
        if (!hasEnemies && !hasDefenses) return;

        bool hitDefense = hasDefenses && (!hasEnemies || UnityEngine.Random.value < chanceToHitDefense);

        Vector3 strikePos;
        if (hitDefense)
        {
            DefenseCharacterBase defense =
                DefenseCharacterBase.All[UnityEngine.Random.Range(0, DefenseCharacterBase.All.Count)];
            strikePos = defense.transform.position;
            defense.TakeDamage(lightningDamage);
            Debug.Log("Lightning hit " + defense.name);
        }
        else
        {
            EnemyBase enemy = EnemyBase.All[UnityEngine.Random.Range(0, EnemyBase.All.Count)];
            strikePos = enemy.transform.position;
            enemy.TakeDamage(lightningDamage);
            Debug.Log("Lightning hit " + enemy.name);
        }

        if (lightningObject != null)
        {
            Lightning bolt = Instantiate(lightningBoltPrefab);
            bolt.Strike(strikePos);
        }

        StartCoroutine(Flash());
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

    private void UpdateCloudCoverage()
    {
        if (weatherCloudMaterial == null)
            return;

        bool needsClouds = currentWeather == WeatherType.Rain || currentWeather == WeatherType.ThunderStorm;
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

    public void ChangeStats()
    {
        //Reset stats and visual effects
        currEnemySpeedMult = 1f;
        currEnemyDamageMult = 1f;
        currTowerRangeMult = 1f;
        currTowerFireRateMult = 1f;
        rainParticles.Stop();
        StopLightning();

        switch (currentWeather)
        {
            case WeatherType.Sunny:
                break;


            case WeatherType.Rain:
                rainParticles.Play();
                currEnemySpeedMult = enemySpeedMult;
                currTowerFireRateMult = towerFireRateMult;
                break;

            case WeatherType.Fog:
                currTowerRangeMult = towerRangeMult;
                break;

            case WeatherType.ThunderStorm:
                rainParticles.Play();
                StartLightning();
                currEnemySpeedMult = enemySpeedMult;
                currEnemyDamageMult = enemyDamageMult;
                break;
        }
        
        UpdateCloudCoverage();
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

    private void OnDisable()
    {
        Shader.SetGlobalFloat(CloudExclusionEnabledId, 0f);
        cloudCoverageTween?.Kill();
        cloudCoverageTween = null;
    }
}