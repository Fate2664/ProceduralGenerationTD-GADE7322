using System;
using Defenses.DefenseCharacters;
using Nova;
using PCG;
using UnityEngine;

namespace Defenses
{
    public class DefenseUpgradeController : MonoBehaviour
    {
        [SerializeField] private CurrencyManager currency;
        [SerializeField] private DefenseHoverController hoverController;
        [SerializeField] private UIBlock upgradeRoot;
        [SerializeField] private ListView upgradesList;
        [SerializeField] private TextBlock defenseTitle;
        [SerializeField] private TextBlock defenseLevel;
        [SerializeField] private UIBlock2D defenseIcon;
        [SerializeField] private UIBlock2D upgradeButton;
        
        private DefenseCharacterBase selectedCharacter;

        private void Awake()
        {
            upgradesList.AddDataBinder<DefenseUpgrade, DefenseUpgradeVisuals>(BindUpgrade);
            upgradeButton.AddGestureHandler<Gesture.OnClick>(HandlePurchase);
            upgradeRoot.gameObject.SetActive(false);
        }

        private void OnEnable()
        {
            hoverController.DefenseSelected += HandleSelectedCharacter;
            currency.BalanceChanged += Refresh;
        }

        private void OnDisable()
        {
            hoverController.DefenseSelected -= HandleSelectedCharacter;
            currency.BalanceChanged -= Refresh;
            ClearSelection();
        }

        private void HandleSelectedCharacter(DefenseCharacterBase character)
        {
            ClearSelection();
            
            if (character == null || character.IsDead)
                return;

            selectedCharacter = character;
            selectedCharacter.Died += HandleSelectedCharacterDied;
            selectedCharacter.OnDefenseUpgraded += Refresh;
            
            //Play show animation
            
            upgradesList.SetDataSource(character.UpgradeData.Upgrades);
            Refresh();
        }

        private void BindUpgrade(Data.OnBind<DefenseUpgrade> evt, DefenseUpgradeVisuals target, int index)
        {
            target.Bind(evt.UserData, selectedCharacter.GetUpgradeValue(evt.UserData.UpgradeType));
        }

        private void HandlePurchase(Gesture.OnClick evt)
        {
            selectedCharacter.TryUpgrade(currency);
            Refresh();
        }

        private void Refresh()
        {
            DefenseUpgradeData data = selectedCharacter.UpgradeData;
            defenseTitle.Text = data.DefenseDisplayName;
            defenseLevel.Text = $"Level {selectedCharacter.CurrentLevel}";
            defenseIcon.SetImage(data.Icon);
            upgradesList.Refresh();
        }

        private void HandleSelectedCharacterDied(DefenseCharacterBase character)
        {
            ClearSelection();
        }

        private void ClearSelection()
        {
            if (selectedCharacter != null)
            {
                selectedCharacter.Died -= HandleSelectedCharacterDied;
                selectedCharacter.OnDefenseUpgraded -= Refresh;
            }
            
            selectedCharacter = null;
            upgradesList.SetDataSource<DefenseUpgrade>(null);
            upgradeRoot.gameObject.SetActive(false);
        }
    }
}