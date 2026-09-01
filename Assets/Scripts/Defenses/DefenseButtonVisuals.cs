using DG.Tweening;
using Nova;
using UnityEngine;
using UnityEngine.Events;

namespace Defenses
{
    [System.Serializable]
    public class DefenseButtonVisuals : ItemVisuals
    {
        [Header("References")] [SerializeField]
        private UIBlock2D background;

        [SerializeField] private UIBlock2D icon;

        [Header("Hover Appearance")] [SerializeField]
        private Color hoverBackgroundColor = Color.white;

        [SerializeField] private float hoverScale = 1.05f;

        [Header("Animation")] [SerializeField] private float pressedScale = 0.98f;
        [SerializeField] private float animationDuration = 0.15f;

        private DefenseOptionData dataSource;

        private Vector3 defaultScale;
        private Color defaultBackgroundColor;
        private bool defaultBodyEnabled;
        private bool initialized;
        private bool isHovered;

        public DefenseOptionData BoundData => dataSource;

        public void Bind(DefenseOptionData data)
        {
            EnsureInitialized();

            dataSource = data;
            
            if (data.Icon != null)
                icon.SetImage(data.Icon);
            else
                icon.ClearImage();

            ResetVisuals();
        }

        private void EnsureInitialized()
        {
            if (initialized)
                return;

            defaultScale = background.transform.localScale;
            defaultBackgroundColor = background.Color;
            defaultBodyEnabled = background.BodyEnabled;
            initialized = true;
        }

        private void ResetVisuals()
        {
            EnsureInitialized();

            isHovered = false;
            background.BodyEnabled = defaultBodyEnabled;
            background.Color = defaultBackgroundColor;
            background.transform.localScale = defaultScale;
        }

        #region Gesture Methods

        public static void HandleHover(Gesture.OnHover evt, DefenseButtonVisuals target, int index)
        {
            target.EnsureInitialized();

            target.isHovered = true;
            target.background.BodyEnabled = true;
            target.background.Color = target.hoverBackgroundColor;
            target.AnimateScale(target.defaultScale * target.hoverScale, Ease.OutBack);
        }

        public static void HandleUnhover(Gesture.OnUnhover evt, DefenseButtonVisuals target, int index)
        {
            target.EnsureInitialized();

            target.isHovered = false;
            target.background.BodyEnabled = target.defaultBodyEnabled;
            target.background.Color = target.defaultBackgroundColor;
            target.AnimateScale(target.defaultScale, Ease.OutQuad);
        }

        public static void HandlePress(Gesture.OnPress evt, DefenseButtonVisuals target)
        {
            target.EnsureInitialized();
            target.AnimateScale(target.defaultScale * target.pressedScale, Ease.OutQuad);
        }

        public static void HandleRelease(Gesture.OnRelease evt, DefenseButtonVisuals target)
        {
            target.EnsureInitialized();
            float scale = target.isHovered ? target.hoverScale : 1f;
            target.AnimateScale(target.defaultScale * scale, Ease.OutBack);
        }

        public static void HandleCancel(Gesture.OnCancel evt, DefenseButtonVisuals target)
        {
            target.EnsureInitialized();
            float scale = target.isHovered ? target.hoverScale : 1f;
            target.AnimateScale(target.defaultScale * scale, Ease.OutQuad);
        }

        #endregion

        private void AnimateScale(Vector3 targetScale, Ease ease)
        {
            background.DOKill();
            background.transform.DOScale(targetScale, animationDuration).SetEase(ease).SetUpdate(true);
        }

        public void Unbind(DefenseOptionData data)
        {
            if (dataSource != data)
                return;

            background.DOKill();
            ResetVisuals();
            dataSource = null;
        }
    }
}