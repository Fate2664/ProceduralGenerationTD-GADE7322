using System;
using PCG;
using UnityEngine;

namespace Enemy
{
    public class EnemyTerrainOutline : MonoBehaviour
    {
        [SerializeField] private Renderer[] characterRenderers;
        [SerializeField] private Material rockyOutlineMaterial;
        [SerializeField] private Material desertOutlineMaterial;
        
        private static readonly int OutlineEnabledId =  Shader.PropertyToID("_DefenseOutlineEnabled");
        private static readonly int OutlineColorId =  Shader.PropertyToID("_OutlineColor");
        private static readonly int OutlineWidthId =  Shader.PropertyToID("_OutlineWidth");

        private EnemyBase enemy;
        private MaterialPropertyBlock propertyBlock;
        private Material currentMaterial;
        private bool initialized;

        private void Awake()
        {
            enemy = GetComponent<EnemyBase>();
            propertyBlock = new MaterialPropertyBlock();
            ApplyOutline(null);
        }

        private void LateUpdate()
        {
            Material material = enemy.GetCurrentPathTerrain() switch
            {
                TerrainType.RockyGround => rockyOutlineMaterial,
                TerrainType.Desert => desertOutlineMaterial,
                _ => null
            };
            
            ApplyOutline(material);
        }

        private void ApplyOutline(Material material)
        {
            if (initialized && currentMaterial == material)
                return;
            
            initialized = true;
            currentMaterial = material;

            foreach (var renderer in characterRenderers)
            {
                renderer.GetPropertyBlock(propertyBlock);
                propertyBlock.SetFloat(OutlineEnabledId, material != null ? 1f : 0f);

                if (material != null)
                {
                    propertyBlock.SetColor(OutlineColorId, material.GetColor(OutlineColorId));
                    propertyBlock.SetFloat(OutlineWidthId, material.GetFloat(OutlineWidthId));
                }
                renderer.SetPropertyBlock(propertyBlock);
            }
        }
    }
}