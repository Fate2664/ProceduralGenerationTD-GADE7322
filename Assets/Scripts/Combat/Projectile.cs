using System;
using System.Collections.Generic;
using UnityEngine;

public class Projectile : MonoBehaviour
{
    [SerializeField] private AnimationCurve heightCurve = new(
        new Keyframe(0f, 0f),
        new Keyframe(0.5f, 1f),
        new Keyframe(1f, 0f));

    [SerializeField] private float arcHeight = 3f;
    [SerializeField] private Vector3 rotationOffset;
    [SerializeField] private float minArcHeight = 2f;
    [SerializeField] private float maxArcHeight = 12f;
    [SerializeField] private AnimationCurve arcHeightByDistance = AnimationCurve.EaseInOut(0, 0, 1f, 1f);
    [SerializeField] private float targetHeightOffset = 1.5f;
    [SerializeField] private GameObject particleEffectPrefab;

    private Transform target;
    private int damage;
    private Vector3 startPosition;
    private float flightDuration;
    private float elapsedTime;
    private bool initialized;
    private float currentArcHeight;
    private float explosionRadius;
    
    public bool IsInFlight => initialized && target != null;

    private void Update()
    {
        if (!initialized)
            return;

        if (target == null)
        {
            Destroy(gameObject);
            return;
        }

        elapsedTime += Time.deltaTime;
        float t = Mathf.Clamp01(elapsedTime / flightDuration);

        //Movement between the two points
        Vector3 previousPosition = transform.position;
        Vector3 targetPosition = target.position + Vector3.up * targetHeightOffset;
        Vector3 position = Vector3.Lerp(startPosition, targetPosition, t);

        //Curve
        position.y += heightCurve.Evaluate(t) * currentArcHeight;
        transform.position = position;

        //Rotate spear along flight
        Vector3 movement = position - previousPosition;
        if (movement.sqrMagnitude > Mathf.Epsilon)
        {
            transform.rotation = Quaternion.LookRotation(movement.normalized) * Quaternion.Euler(rotationOffset);
        }

        if (t >= 1f)
        {
            Impact();
        }
    }

    public void InitializeProjectile(Transform target, float moveSpeed, int damage, float explosionRadius = 0f)
    {
        if (target == null)
        {
            Destroy(gameObject);
            return;
        }

        this.target = target;
        this.damage = damage;
        this.explosionRadius = explosionRadius;
        startPosition = transform.position;
        elapsedTime = 0f;

        Vector3 offset = target.position - startPosition;
        offset.y = 0f;
        float safeMaxDistance = Mathf.Max(maxArcHeight, minArcHeight + 0.01f);
        float normalizedDistance = Mathf.InverseLerp(minArcHeight, safeMaxDistance, offset.magnitude);

        currentArcHeight = arcHeight * Mathf.Clamp01(arcHeightByDistance.Evaluate(normalizedDistance));
        Vector3 targetPosition = target.position + Vector3.up * targetHeightOffset;
        float flightDistance = Vector3.Distance(startPosition, targetPosition);

        flightDuration = Mathf.Max(0.01f, flightDistance / Mathf.Max(0.01f, moveSpeed));

        initialized = true;
    }

    private void Impact()
    {
        if (!initialized)
            return;

        initialized = false;

        if (explosionRadius > 0f)
        {
            ApplyExplosionDamage();
        }
        else if (target != null && target.TryGetComponent<IDamageable>(out IDamageable damageable))
        {
            damageable.TakeDamage(damage);
        }

        PlayImpactEffect();
        Destroy(gameObject);
    }

    private void ApplyExplosionDamage()
    {
        Collider[] hits = Physics.OverlapSphere(transform.position, explosionRadius, Physics.AllLayers,
            QueryTriggerInteraction.Collide);

        var damagedEnemies = new HashSet<Enemy.EnemyBase>();

        foreach (var hit in hits)
        {
            Enemy.EnemyBase enemy = hit.GetComponentInParent<Enemy.EnemyBase>();

            if (enemy == null)
                continue;

            if (!damagedEnemies.Add(enemy))
                continue;

            enemy.TakeDamage(damage);
        }
    }

    private void PlayImpactEffect()
    {
        if (particleEffectPrefab == null)
            return;

        GameObject effect = Instantiate(particleEffectPrefab, transform.position, transform.rotation);
        if (effect.TryGetComponent<ParticleSystem>(out ParticleSystem particles))
        {
            var main = particles.main;
            main.loop = false;
            main.stopAction = ParticleSystemStopAction.Destroy;
        }
        else
        {
            Destroy(effect, 3f);
        }
    }

    private void OnTriggerEnter(Collider other)
    {
        if (!initialized || other.isTrigger)
            return;

        if (explosionRadius > 0f)
        {
            Impact();
            return;
        }

        if (target != null && (other.transform == target || other.transform.IsChildOf(target)))
        {
            Impact();
            return;
        }

        if (other.GetComponentInParent<Enemy.EnemyBase>() != null)
            return;

        initialized = false;
        //Destroy projectile when it hits an obstacle
        Destroy(gameObject);
    }
}