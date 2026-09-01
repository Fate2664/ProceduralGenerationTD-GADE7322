using System;
using System.Collections.Generic;
using DG.Tweening;
using Nova;
using PCG;
using UnityEngine;

namespace Defenses
{
    public class DefensePlacementManager : MonoBehaviour
    {
        [Header("References")] 
        [SerializeField] private ListView defensesOptionList;
        [SerializeField] private PlacementGridManager placementGrid;
        [SerializeField] private List<DefenseOptionData> defensesOptions = new();

        [Header("Placement")] 
        [SerializeField] private float localPlacementYOffset = 0.5f;
        
        private DefenseOptionData selectedDefense;

        private void Awake()
        {
            RegisterHandlers();
            
            defensesOptionList.SetDataSource(defensesOptions);
        }

        private void OnEnable()
        {
            placementGrid.CellClicked += HandleCellClicked;
        }

        private void RegisterHandlers()
        {
            defensesOptionList.AddGestureHandler<Gesture.OnHover, DefenseButtonVisuals>(DefenseButtonVisuals.HandleHover);
            defensesOptionList.AddGestureHandler<Gesture.OnUnhover, DefenseButtonVisuals>(DefenseButtonVisuals.HandleUnhover);
            
            defensesOptionList.AddGestureHandler<Gesture.OnPress, DefenseButtonVisuals>(HandleDefensePressed);
            defensesOptionList.AddGestureHandler<Gesture.OnRelease, DefenseButtonVisuals>(HandleDefenseReleased);
            defensesOptionList.AddGestureHandler<Gesture.OnCancel, DefenseButtonVisuals>(HandleDefenseCanceled);
            
            defensesOptionList.AddDataBinder<DefenseOptionData, DefenseButtonVisuals>(BindDefenseOption);
            defensesOptionList.AddDataUnbinder<DefenseOptionData, DefenseButtonVisuals>(UnbindDefenseOption);
            
            
        }

        private void HandleDefenseReleased(Gesture.OnRelease evt, DefenseButtonVisuals target, int index)
        {
            DefenseButtonVisuals.HandleRelease(evt, target);

            if (!evt.WasDragged || target.BoundData != selectedDefense)
                return;
            
            if (placementGrid.TryGetCell(evt.Interaction.Ray, out GridTile tile))
                TryPlaceDefense(tile);
        }

        private void HandleDefensePressed(Gesture.OnPress evt, DefenseButtonVisuals target, int index)
        {
            DefenseButtonVisuals.HandlePress(evt, target);
            if (target.BoundData == null)
                return;
            placementGrid.ShowGrid();
        }
        
        private void HandleDefenseCanceled(Gesture.OnCancel evt, DefenseButtonVisuals target, int index)
        {
            DefenseButtonVisuals.HandleCancel(evt, target);
            if (target.BoundData == selectedDefense)
                selectedDefense = null;
            
            placementGrid.HideGrid();
        }

        private void BindDefenseOption(Data.OnBind<DefenseOptionData> evt, DefenseButtonVisuals target, int index)
        {
            target.Bind(evt.UserData);
        }
        
        private void UnbindDefenseOption(Data.OnUnbind<DefenseOptionData> evt, DefenseButtonVisuals target, int index)
        {
            target.Unbind(evt.UserData);
        }

        private void HandleCellClicked(GridTile tile)
        {
            TryPlaceDefense(tile);
        }

        private bool TryPlaceDefense(GridTile tile)
        {
            if (selectedDefense == null || tile == null || !tile.CanBuild)
                return false;

            GameObject prefab = selectedDefense.prefab;
            Vector3 position = tile.transform.TransformPoint(new Vector3(0f, localPlacementYOffset, 0f));
            GameObject defense = Instantiate(prefab, position, prefab.transform.rotation, tile.transform);
            tile.SetOccupant(defense);

            selectedDefense = null;
            placementGrid.HideGrid();
            return true;
        }
    }
}