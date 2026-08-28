using System;
using DG.Tweening;
using UnityEngine;

namespace Spawning
{
    public class SpawnEffects : MonoBehaviour
    {
        [SerializeField] private GameObject spawnVFX;
        [SerializeField] private float animationDuration = 1f;

        private void Start()
        {
            transform.localScale = Vector3.zero;
            transform.DOScale(Vector3.one, animationDuration);

            if (spawnVFX != null)
            {
                Instantiate(spawnVFX, transform.position, transform.rotation);
            }
        }
    }
}