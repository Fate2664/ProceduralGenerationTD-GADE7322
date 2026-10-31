using System;
using Defenses.DefenseCharacters;
using PCG;
using UnityEngine;

namespace Defenses
{
    public class DefenseUpgradeController : MonoBehaviour
    {
        [SerializeField] private CurrencyManager currency;
        [SerializeField] private DefenseHoverController hoverController;

        private DefenseCharacterBase selectedCharacter;

        private void OnEnable()
        {
            hoverController.DefenseSelected += HandleSelectedCharacter;
        }

        private void OnDisable()
        {
            hoverController.DefenseSelected -= HandleSelectedCharacter;
            ClearSelection();
        }

        private void HandleSelectedCharacter(DefenseCharacterBase character)
        {
            ClearSelection();
            
            if (character == null || character.IsDead)
                return;

            selectedCharacter = character;
            selectedCharacter.Died += HandleSelectedCharacterDied;
        }

        private void HandleSelectedCharacterDied(DefenseCharacterBase character)
        {
            ClearSelection();
        }

        private void ClearSelection()
        {
            if (selectedCharacter != null)
                selectedCharacter.Died -= HandleSelectedCharacterDied;
            
            selectedCharacter = null;
        }
    }
}