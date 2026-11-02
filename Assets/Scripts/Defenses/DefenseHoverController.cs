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
        
        public event Action<DefenseCharacterBase> DefenseSelected;

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
                DefenseCharacterBase character = hit.collider.GetComponentInParent<DefenseCharacterBase>();

                if (character != null && !character.IsDead)
                {
                    nextOutline = character.GetComponent<DefenseHoverOutline>();
                }
            }
            
            SetHovered(nextOutline);

            if (mouse.leftButton.wasPressedThisFrame)
            {
                DefenseCharacterBase clickedCharacter = hoveredOutline != null ? hoveredOutline.Character : null;
                DefenseSelected?.Invoke(clickedCharacter);
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