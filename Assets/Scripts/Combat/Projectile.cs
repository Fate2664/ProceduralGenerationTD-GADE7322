using System;
using UnityEngine;

public class Projectile : MonoBehaviour
{
    [SerializeField] private AnimationCurve heightCurve = new (
        new Keyframe(0f, 0f),
        new Keyframe(0.5f, 1f),
        new Keyframe(1f, 0f));
    [SerializeField] private float arcHeight = 3f;
    [SerializeField] private Vector3 rotationOffset;
    [SerializeField] private float minArcHeight = 2f;
    [SerializeField] private float maxArcHeight = 12f;
    [SerializeField] private AnimationCurve arcHeightByDistance = AnimationCurve.EaseInOut(0, 0, 1f, 1f);
    
    private Transform target;
    private int damage;
    private Vector3 startPosition;
    private float flightDuration;
    private float elapsedTime;
    private bool initialized;
    private float currentArcHeight;

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
        Vector3 position = Vector3.Lerp(startPosition, target.position, t);
        
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
            if (target.TryGetComponent<IDamageable>(out IDamageable damageable))
                damageable.TakeDamage(damage);
            //Apply damage and effects
            Destroy(gameObject);
        }
    }

    public void InitializeProjectile(Transform target, float moveSpeed, int damage)
    {
        if (target == null)
        {
            Destroy(gameObject);
            return;
        }
        
        this.target = target;
        this.damage = damage;
        startPosition = transform.position;
        elapsedTime = 0f;
        
        Vector3 offset = target.position - startPosition;
        offset.y = 0f;
        float safeMaxDistance = Mathf.Max(maxArcHeight, minArcHeight + 0.01f);
        float normalizedDistance = Mathf.InverseLerp(minArcHeight, safeMaxDistance, offset.magnitude);
        
        currentArcHeight = arcHeight * Mathf.Clamp01(arcHeightByDistance.Evaluate(normalizedDistance));
        float flightDistance = Vector3.Distance(startPosition, target.position);

        flightDuration = flightDistance / moveSpeed;
        
        initialized = true;
    }
    
}
