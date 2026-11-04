using System;
using Defenses.DefenseCharacters;
using UnityEngine;

namespace Defenses
{
    public class DefenseHoverOutline : MonoBehaviour
    {
        [SerializeField] private Renderer[] characterRenderers;
        
        private static readonly int OutlineEnabledId = Shader.PropertyToID("_DefenseOutlineEnabled");
        private MaterialPropertyBlock propertyBlock;
        
        public UpgradeableDefense Defense { get; private set; }

        private void Awake()
        {
            Defense = GetComponent<UpgradeableDefense>();
            propertyBlock = new MaterialPropertyBlock();
            
            SetHovered(false);
        }

        public void SetHovered(bool hovered)
        {
            foreach (var characterRenderer in characterRenderers)
            {
                if (characterRenderer == null)
                    continue;
                
                characterRenderer.GetPropertyBlock(propertyBlock);
                propertyBlock.SetFloat(OutlineEnabledId, hovered ? 1f : 0f);
                characterRenderer.SetPropertyBlock(propertyBlock);
            }
        }

        private void OnDisable()
        {
            SetHovered(false);
        }
    }
}