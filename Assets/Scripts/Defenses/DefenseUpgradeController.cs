using System;
using Defenses.DefenseCharacters;
using PCG;
using UnityEngine;

namespace Defenses
{
    public class DefenseUpgradeController : MonoBehaviour
    {
        [SerializeField] private PlacementGridManager placementGrid;
        [SerializeField] private CurrencyManager currency;

        private DefenseCharacterBase selectedCharacter;

        private void OnEnable()
        {
            placementGrid.CellClicked += HandleCellClicked;
        }

        private void OnDisable()
        {
            placementGrid.CellClicked -= HandleCellClicked;
        }

        private void HandleCellClicked(GridTile tile)
        {
            ClearSelection();
            
            if (tile.Occupant == null)
                return;
            
            selectedCharacter = tile.Occupant.GetComponent<DefenseCharacterBase>();
            if (selectedCharacter != null)
                selectedCharacter.Died += HandleSelectedCharacterDied;
        }

        private void HandleSelectedCharacterDied(DefenseCharacterBase character)
        {
            ClearSelection();
        }

        private void ClearSelection()
        {
            selectedCharacter = null;
        }
    }
}