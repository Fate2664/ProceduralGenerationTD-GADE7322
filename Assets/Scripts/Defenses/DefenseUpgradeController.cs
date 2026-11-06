using System;
using Defenses.DefenseCharacters;
using DG.Tweening;
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
        [SerializeField] private ParticleSystem selectedIndicator;
        [SerializeField] private TextBlock costText;
        [SerializeField] private Vector3 selectedIndicatorOffset = new Vector3(0f, 0.5f, 0f);

        private UpgradeableDefense selectedCharacter;
        private ParticleSystem selectedIndicatorInstance;

        private void Awake()
        {
            upgradesList.AddDataBinder<DefenseUpgrade, DefenseUpgradeVisuals>(BindUpgrade);
            upgradeButton.AddGestureHandler<Gesture.OnClick>(HandlePurchase);
            upgradeRoot.transform.localScale = Vector3.zero;
        }

        private void OnEnable()
        {
            hoverController.DefenseSelected += HandleSelectedCharacter;
            currency.BalanceChanged += Refresh;
        }

        private void OnDisable()
        {
            if (hoverController != null)
                hoverController.DefenseSelected -= HandleSelectedCharacter;
            
            if (currency != null)
                currency.BalanceChanged -= Refresh;
            
            ClearSelection();
        }

        private void HandleSelectedCharacter(UpgradeableDefense defense)
        {
            ClearSelection();

            if (defense == null || defense.IsDead || defense.UpgradeData == null)
                return;

            selectedCharacter = defense;
            selectedCharacter.Unavailable += HandleSelectedCharacterUnavailable;
            selectedCharacter.OnDefenseUpgraded += Refresh;
            
            ShowSelectedIndicator();

            upgradeRoot.transform.DOKill();
            upgradeRoot.transform.DOScale(1f, 0.35f).SetEase(Ease.OutCubic);

            Refresh();
        }

        private void BindUpgrade(Data.OnBind<DefenseUpgrade> evt, DefenseUpgradeVisuals target, int index)
        {
            target.Bind(evt.UserData, selectedCharacter.GetUpgradeValue(evt.UserData.UpgradeType));
        }

        private void HandlePurchase(Gesture.OnClick evt)
        {
            if (selectedCharacter == null || selectedCharacter.IsDead)
                return;

            if (selectedCharacter.TryUpgrade(currency))
                ClearSelection();
        }

        private void Refresh()
        {
            if (selectedCharacter == null)
                return;

            DefenseUpgradeData data = selectedCharacter.UpgradeData;
            if (selectedCharacter.IsDead || data == null)
            {
                ClearSelection();
                return;
            }
            defenseTitle.Text = data.DefenseDisplayName;
            defenseLevel.Text = $"Level {selectedCharacter.CurrentLevel}";
            costText.Text = data.Cost.ToString();
            defenseIcon.SetImage(data.Icon);
            upgradesList.SetDataSource(data.Upgrades);
            upgradesList.Refresh();
        }

        private void HandleSelectedCharacterUnavailable()
        {
            ClearSelection();
        }

        private void ShowSelectedIndicator()
        {
            HideSelectedIndicator();

            if (selectedCharacter == null)
                return;
            
            selectedIndicatorInstance = Instantiate(selectedIndicator, selectedCharacter.transform, false);
            selectedIndicatorInstance.transform.localPosition = selectedIndicatorOffset;
            selectedIndicatorInstance.gameObject.SetActive(true);
            
            selectedIndicatorInstance.Stop(true, ParticleSystemStopBehavior.StopEmittingAndClear);
            selectedIndicatorInstance.Play(true);
        }

        private void HideSelectedIndicator()
        {
            if (selectedIndicatorInstance == null)
                return;
            
            selectedIndicatorInstance.Stop(true, ParticleSystemStopBehavior.StopEmittingAndClear);
            selectedIndicatorInstance.gameObject.SetActive(false);
            Destroy(selectedIndicatorInstance.gameObject);
            selectedIndicatorInstance = null;
        }

        private void ClearSelection()
        {
            HideSelectedIndicator();
            
            if (selectedCharacter != null)
            {
                selectedCharacter.Unavailable -= HandleSelectedCharacterUnavailable;
                selectedCharacter.OnDefenseUpgraded -= Refresh;
            }

            selectedCharacter = null;
            
            if (upgradesList != null)
                upgradesList.SetDataSource<DefenseUpgrade>(null);

            if (upgradeRoot == null)
                return;

            upgradeRoot.transform.DOKill();
            upgradeRoot.transform.DOScale(0f, 0.35f).SetEase(Ease.OutCubic);
        }
    }
}