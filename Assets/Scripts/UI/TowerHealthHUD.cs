using System;
using Nova;
using PCG;
using UnityEngine;

namespace UI
{
    public class TowerHealthHUD : MonoBehaviour
    {
        [SerializeField] private WorldGenerator worldGenerator;
        [SerializeField] private UIBlock2D healthFillBar;

        private Tower tower;

        private void Start()
        {
            tower = worldGenerator.Tower.GetComponent<Tower>();
            tower.OnHealthChanged += SetHealthPercentage;
            
            SetHealthPercentage(tower.HealthPercentage);
        }

        private void SetHealthPercentage(float percentage)
        {
            healthFillBar.Size.X = Length.Percentage(Mathf.Clamp01(percentage));

        }

        private void OnDestroy()
        {
            if (tower != null)
                tower.OnHealthChanged -= SetHealthPercentage;
        }
    }
}