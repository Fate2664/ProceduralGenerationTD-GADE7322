using Nova;
using UnityEngine;

namespace UI
{
    public class CharacterHealthBar : MonoBehaviour
    {
        [SerializeField] private UIBlock2D fillBar;

        public void SetHealth(float currentHealth, float maxHealth)
        {
            float percentage = maxHealth > 0f ? Mathf.Clamp01(currentHealth / maxHealth) : 0f;
            fillBar.Size.X = Length.Percentage(percentage);
        }
    }
}