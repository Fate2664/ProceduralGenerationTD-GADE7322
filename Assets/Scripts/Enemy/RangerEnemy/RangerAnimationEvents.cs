using System;
using UnityEngine;

namespace Enemy.RangerEnemy
{
    public class RangerAnimationEvents : MonoBehaviour
    {
        private RangerEnemy ranger;

        private void Awake()
        {
            ranger = GetComponentInParent<RangerEnemy>();
        }

        public void ShootPair(int pairIndex)
        {
            if (ranger != null)
                ranger.ShootPair(pairIndex);
        }

        public void FinishShooting()
        {
            if (ranger != null)
                ranger.FinishShooting();
        }
    }
}