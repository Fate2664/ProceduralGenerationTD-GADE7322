using System;
using Defenses.DefenseCharacters;
using Nova;
using UnityEngine;
using UnityEngine.InputSystem;

namespace Defenses
{
    public class DefenseHoverController : MonoBehaviour
    {
        [SerializeField] private UnityEngine.Camera camera;
        [SerializeField] private DefensePlacementManager placementManager;
        [SerializeField] private LayerMask worldRaycastLayerMask = Physics.DefaultRaycastLayers;
        [SerializeField] private LayerMask blockingUIMask;
        [SerializeField] private float maxRayDistance = 500f;

        private DefenseHoverOutline hoveredOutline;
        
        public event Action<UpgradeableDefense> DefenseSelected;

        private void Update()
        {
            Mouse mouse = Mouse.current;
            
            if (placementManager.IsPlacingDefense)
            {
                SetHovered(null);
                return;
            }

            Vector2 pointerPosition = mouse.position.ReadValue();
            Ray uiRay = camera.ScreenPointToRay(pointerPosition);

            if (Interaction.Raycast(uiRay, out UIBlockHit uiHit, float.PositiveInfinity, blockingUIMask))
            {
                SetHovered(null);
                return;
            }
            
            Ray worldRay = camera.ScreenPointToRay(pointerPosition);
            DefenseHoverOutline nextOutline = null;

            if (Physics.Raycast(worldRay, out RaycastHit hit, maxRayDistance, worldRaycastLayerMask,
                    QueryTriggerInteraction.Collide))
            {
                UpgradeableDefense defense = hit.collider.GetComponentInParent<UpgradeableDefense>();

                if (defense != null && !defense.IsDead)
                {
                    nextOutline = defense.GetComponent<DefenseHoverOutline>();
                }
            }
            
            SetHovered(nextOutline);

            if (mouse.leftButton.wasPressedThisFrame)
            {
                UpgradeableDefense clickedDefense = hoveredOutline != null ? hoveredOutline.Defense : null;
                DefenseSelected?.Invoke(clickedDefense);
            }
        }

        private void SetHovered(DefenseHoverOutline nextOutline)
        {
            if (hoveredOutline == nextOutline)
                return;
            
            if (hoveredOutline != null)
                hoveredOutline.SetHovered(false);
            
            hoveredOutline = nextOutline;
            
            if (hoveredOutline != null)
                hoveredOutline.SetHovered(true);
        }

        private void OnDisable()
        {
            SetHovered(null);
        }
    }
}