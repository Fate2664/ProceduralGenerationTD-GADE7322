using System;
using DG.Tweening;
using UnityEngine;

namespace Spawning
{
    public class SpawnEffects : MonoBehaviour
    {
        [SerializeField] private GameObject spawnVFX;
        [SerializeField] private float animationDuration = 1f;

        private Vector3 originalScale;

        private void Start()
        {
            originalScale = transform.localScale;
            transform.localScale = Vector3.zero;
            transform.DOScale(originalScale, animationDuration);

            if (spawnVFX != null)
            {
                Instantiate(spawnVFX, transform.position, transform.rotation);
            }
        }
    }
}