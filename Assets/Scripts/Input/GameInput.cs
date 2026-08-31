using System;
using UnityEngine;
using UnityEngine.InputSystem;

[CreateAssetMenu(menuName = "Input/GameInput")]
public class GameInput : ScriptableObject, PlayerInputActions.IGameplayActions, PlayerInputActions.IUIActions
{
    #region Class Variables
    
        public PlayerInputActions InputActions {get ; private set;}
        public bool IsCameraLookHeld { get; private set; }
        public Vector2 CameraLookInput {get; private set;}
        
    #endregion
    
    #region Startup & Update Methods

    private void OnEnable()
    {
        if (InputActions == null)
        {
            InputActions = new PlayerInputActions();
            InputActions.Gameplay.SetCallbacks(this);
            InputActions.UI.SetCallbacks(this);
        }
        InputActions.Enable();
    }

   

    #endregion
    
    #region Gameplay Actions

    public void OnMouseLook(InputAction.CallbackContext context)
    {
        CameraLookInput = context.ReadValue<Vector2>();
    }

    public void OnPause(InputAction.CallbackContext context)
    {
        return;
    }

    public void OnRightClick(InputAction.CallbackContext context)
    {
        IsCameraLookHeld = context.ReadValueAsButton();
    }

    #endregion
    
    #region UI Actions
    
    public void OnNavigation(InputAction.CallbackContext context)
    {
        return;
    }

    public void OnApply(InputAction.CallbackContext context)
    {
        return;
    }
    #endregion
}
