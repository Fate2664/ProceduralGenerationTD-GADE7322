using System;
using Input;
using Unity.Cinemachine;
using UnityEngine;

namespace Camera
{
    public class CameraLook : MonoBehaviour
    {
        [SerializeField] private GameInput input;
        [SerializeField] private float horizontalSensitivity = 0.1f;
        [SerializeField] private float verticalSensitivity = 0.06f;
        [SerializeField] private bool invertVertical;
        
        private CinemachineOrbitalFollow orbitalFollow;

        private void Awake()
        {
            orbitalFollow = GetComponent<CinemachineOrbitalFollow>();
        }

        private void Update()
        {
            if (!input.IsCameraLookHeld)
                return;

            Vector2 lookInput = input.CameraLookInput;

            float horizontalValue =
                orbitalFollow.HorizontalAxis.Value
                + lookInput.x * horizontalSensitivity;

            orbitalFollow.HorizontalAxis.Value =
                orbitalFollow.HorizontalAxis.ClampValue(horizontalValue);

            float verticalDirection = invertVertical ? 1f : -1f;
            float verticalValue =
                orbitalFollow.VerticalAxis.Value
                + lookInput.y * verticalSensitivity * verticalDirection;

            orbitalFollow.VerticalAxis.Value =
                orbitalFollow.VerticalAxis.ClampValue(verticalValue);
        }
    }
}
