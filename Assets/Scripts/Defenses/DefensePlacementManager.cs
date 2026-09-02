using System;
using System.Collections.Generic;
using Defenses.DefenseCharacters;
using DG.Tweening;
using Nova;
using PCG;
using UnityEngine;

namespace Defenses
{
    public class DefensePlacementManager : MonoBehaviour
    {
        [Header("References")] [SerializeField]
        private ListView defensesOptionList;

        [SerializeField] private PlacementGridManager placementGrid;
        [SerializeField] private List<DefenseOptionData> defensesOptions = new();

        private DefenseOptionData selectedDefense;
        private GameObject dragPreview;
        private GridTile previewTile;

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
            defensesOptionList.AddGestureHandler<Gesture.OnHover, DefenseButtonVisuals>(
                DefenseButtonVisuals.HandleHover);
            defensesOptionList.AddGestureHandler<Gesture.OnUnhover, DefenseButtonVisuals>(DefenseButtonVisuals
                .HandleUnhover);

            defensesOptionList.AddGestureHandler<Gesture.OnPress, DefenseButtonVisuals>(HandleDefensePressed);
            defensesOptionList.AddGestureHandler<Gesture.OnRelease, DefenseButtonVisuals>(HandleDefenseReleased);
            defensesOptionList.AddGestureHandler<Gesture.OnCancel, DefenseButtonVisuals>(HandleDefenseCanceled);
            defensesOptionList.AddGestureHandler<Gesture.OnDrag, DefenseButtonVisuals>(HandleDefenseDragged);

            defensesOptionList.AddDataBinder<DefenseOptionData, DefenseButtonVisuals>(BindDefenseOption);
            defensesOptionList.AddDataUnbinder<DefenseOptionData, DefenseButtonVisuals>(UnbindDefenseOption);
        }

        private void HandleDefenseReleased(Gesture.OnRelease evt, DefenseButtonVisuals target, int index)
        {
            DefenseButtonVisuals.HandleRelease(evt, target);

            if (!evt.WasDragged)
                return;

            DestroyDragPreview();

            if (placementGrid.TryGetCell(evt.Interaction.Ray, out GridTile tile) && target.BoundData == selectedDefense)
            {
                TryPlaceDefense(tile);
            }

            selectedDefense = null;
            placementGrid.HideGrid();
        }

        private void HandleDefensePressed(Gesture.OnPress evt, DefenseButtonVisuals target, int index)
        {
            DefenseButtonVisuals.HandlePress(evt, target);
            selectedDefense = target.BoundData;

            if (target.BoundData == null)
                return;
            placementGrid.ShowGrid();
        }

        private void HandleDefenseCanceled(Gesture.OnCancel evt, DefenseButtonVisuals target, int index)
        {
            DefenseButtonVisuals.HandleCancel(evt, target);
            DestroyDragPreview();
            selectedDefense = null;
            placementGrid.HideGrid();
        }

        private void HandleDefenseDragged(Gesture.OnDrag evt, DefenseButtonVisuals target, int index)
        {
            if (selectedDefense == null || target.BoundData != selectedDefense)
                return;

            if (dragPreview == null)
            {
                dragPreview = Instantiate(selectedDefense.prefab);

                //Prevent preview from interacting with physics
                foreach (Collider previewCollider in dragPreview.GetComponentsInChildren<Collider>())
                    previewCollider.enabled = false;
            }

            Ray cursorRay = evt.Interaction.Ray;

            //Snap to a grid tile when the cursor is over one.
            if (placementGrid.TryGetCell(cursorRay, out GridTile tile))
            {
                previewTile = tile;
                dragPreview.transform.position = tile.transform.position;
                return;
            }

            previewTile = null;

            //Otherwise follow the cursor
            Plane placementPlane = new Plane(Vector3.up, placementGrid.Root.transform.position);

            if (placementPlane.Raycast(cursorRay, out float distance))
            {
                Vector3 position = cursorRay.GetPoint(distance);
                dragPreview.transform.position = position;
            }
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
            Vector3 position = tile.transform.position;
            Transform pathTarget = placementGrid.WorldGenerator.GetClosestPathTile(position);
            GameObject defense = Instantiate(prefab, position, prefab.transform.rotation, tile.transform);
            defense.GetComponent<DefenseCharacterBase>()?.Initialize(pathTarget);
            tile.SetOccupant(defense);

            selectedDefense = null;
            placementGrid.HideGrid();
            return true;
        }

        private void DestroyDragPreview()
        {
            if (dragPreview != null)
                Destroy(dragPreview);

            dragPreview = null;
            previewTile = null;
        }

        private void OnDisable()
        {
            placementGrid.CellClicked -= HandleCellClicked;
            DestroyDragPreview();
            selectedDefense = null;
        }
    }
}