using DG.Tweening;
using Nova;
using UnityEngine;
using UnityEngine.Events;

public class MenuButtonVisuals : MonoBehaviour
{
    [Header("References")]
    [SerializeField] private UIBlock2D background;

    [Header("Hover Appearance")] 
    [SerializeField] private Color hoverBackgroundColor = Color.white;
    [SerializeField] private float hoverScale = 1.05f;

    [Header("Animation")] 
    [SerializeField] private float pressedScale = 0.98f;
    [SerializeField] private float animationDuration = 0.15f;

    [Header("Events")] 
    [SerializeField] private UnityEvent onClicked;

    private Vector3 defaultScale;
    private Color defaultBackgroundColor;
    private bool defaultBodyEnabled;
    private bool isHovered;

    private void Awake()
    {
        defaultScale = background.transform.localScale;
        defaultBackgroundColor = background.Color;
        defaultBodyEnabled = background.BodyEnabled;

    }

    private void OnEnable()
    {
        background.AddGestureHandler<Gesture.OnHover>(HandleHover);
        background.AddGestureHandler<Gesture.OnUnhover>(HandleUnhover);
        background.AddGestureHandler<Gesture.OnPress>(HandlePress);
        background.AddGestureHandler<Gesture.OnRelease>(HandleRelease);
        background.AddGestureHandler<Gesture.OnCancel>(HandleCancel);
        background.AddGestureHandler<Gesture.OnClick>(HandleClick);
    }

    private void HandleHover(Gesture.OnHover evt)
    {
        isHovered = true;
        background.BodyEnabled = true;
        background.Color = hoverBackgroundColor;

        AnimateScale(defaultScale * hoverScale, Ease.OutBack);
    }

    private void HandleUnhover(Gesture.OnUnhover evt)
    {
        isHovered = false;
        background.BodyEnabled = defaultBodyEnabled;
        background.Color = defaultBackgroundColor;

        AnimateScale(defaultScale, Ease.OutQuad);
    }

    private void HandlePress(Gesture.OnPress evt)
    {
        AnimateScale(defaultScale * pressedScale, Ease.OutQuad);
    }

    private void HandleRelease(Gesture.OnRelease evt)
    {
        AnimateScale(defaultScale * (isHovered ? hoverScale : 1f), Ease.OutBack);
    }

    private void HandleCancel(Gesture.OnCancel evt)
    {
        AnimateScale(defaultScale * (isHovered ? hoverScale : 1f), Ease.OutQuad);
    }

    private void HandleClick(Gesture.OnClick evt)
    {
        onClicked?.Invoke();
    }

    private void AnimateScale(Vector3 targetScale, Ease ease)
    {
        background.DOKill();
        background.transform
            .DOScale(targetScale, animationDuration)
            .SetEase(ease)
            .SetUpdate(true);
    }
}