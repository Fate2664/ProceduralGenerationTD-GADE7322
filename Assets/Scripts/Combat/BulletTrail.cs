using UnityEngine;
using UnityEngine.SceneManagement;


public sealed class BulletTrail : MonoBehaviour
{
    [SerializeField] private ParticleSystem trailPrefab;

    private ParticleSystem trail;
    private float fadeDuration;

    private void OnEnable()
    {
        if (trailPrefab == null)
            return;

        trail = Instantiate(trailPrefab, transform.position, transform.rotation);
        SceneManager.MoveGameObjectToScene(trail.gameObject, gameObject.scene);
        ParticleSystem[] systems = trail.GetComponentsInChildren<ParticleSystem>();
        fadeDuration = 0f;
        foreach (ParticleSystem system in systems)
        {
            var main = system.main;
            fadeDuration = Mathf.Max(fadeDuration, main.startLifetime.constantMax);
        }
        trail.Play(true);
    }

    private void LateUpdate()
    {
        if (trail != null)
            trail.transform.SetPositionAndRotation(transform.position, transform.rotation);
    }

    private void OnDisable()
    {
        if (trail == null)
            return;

        trail.transform.SetPositionAndRotation(transform.position, transform.rotation);
        trail.Stop(true, ParticleSystemStopBehavior.StopEmitting);
        Destroy(trail.gameObject, fadeDuration + 0.05f);
        trail = null;
    }
}
