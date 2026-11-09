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
        
        //UI Actions
        public event UnityAction<bool> Exit  =  delegate { };
        public event UnityAction<bool> RestoreDefaults  =  delegate { };
        public event UnityAction<bool> Apply  =  delegate { };
        public event UnityAction<float> VerticalNav  =  delegate { };
        public event UnityAction<float> HorizontalNav  =  delegate { };
        public event UnityAction<float> TabNav = delegate { };
        
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

        void PlayerInputActions.IUIActions.OnExit(InputAction.CallbackContext context)
        {
            Exit.Invoke(context.phase == InputActionPhase.Performed);
        }

        public void OnVerticalNavigation(InputAction.CallbackContext context)
        {
            VerticalNav.Invoke(context.ReadValue<float>());
        }

        public void OnHorizontalNavigation(InputAction.CallbackContext context)
        {
            HorizontalNav.Invoke(context.ReadValue<float>());
        }

        void PlayerInputActions.IUIActions.OnRestoreDefaults(InputAction.CallbackContext context)
        {
            RestoreDefaults.Invoke(context.phase == InputActionPhase.Performed);
        }

        void PlayerInputActions.IUIActions.OnApply(InputAction.CallbackContext context)
        {
            Apply.Invoke(context.phase == InputActionPhase.Performed);
        }

        public void OnTabNavigation(InputAction.CallbackContext context)
        {
            TabNav.Invoke(context.ReadValue<float>());
        }
        
        #endregion
    }
}
