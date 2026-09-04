using UnityEngine;
using UnityEngine.Events;
using UnityEngine.InputSystem;

namespace Input
{
    [CreateAssetMenu(menuName = "Input/GameInput")]
    public class GameInput : ScriptableObject, PlayerInputActions.IGameplayActions, PlayerInputActions.IUIActions
    {
        #region Class Variables
    
        public PlayerInputActions InputActions {get ; private set;}
        public bool IsCameraLookHeld { get; private set; }
        public Vector2 CameraLookInput {get; private set;}
        
        public event UnityAction<bool> Pause = delegate { };

        public bool PausePressed => InputActions.Gameplay.Pause.IsPressed();
        
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

        private void OnDisable()
        {
            InputActions?.Disable();
        }

        #endregion
    
        #region Gameplay Actions

        public void OnMouseLook(InputAction.CallbackContext context)
        {
            //Cinemachine reads this action
        }

        public void OnPause(InputAction.CallbackContext context)
        {
            Pause.Invoke(context.phase == InputActionPhase.Performed);
        }

        public void OnZoom(InputAction.CallbackContext context) 
        {
            //Cinemachine reads this action
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
}
