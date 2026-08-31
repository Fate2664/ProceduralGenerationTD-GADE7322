using System;
using Unity.Cinemachine;
using UnityEngine;

namespace Camera
{
    public class CameraLook : MonoBehaviour
    {
        [SerializeField] private GameInput input;
        [SerializeField] private float sensitivity = 0.1f;
        
        private CinemachineOrbitalFollow orbitalFollow;

        private void Awake()
        {
            orbitalFollow = GetComponent<CinemachineOrbitalFollow>();
        }

        private void Update()
        {
            if (!input.IsCameraLookHeld)
                return;
            
            float newValue = orbitalFollow.HorizontalAxis.Value + input.CameraLookInput.x * sensitivity;
            orbitalFollow.HorizontalAxis.Value = orbitalFollow.HorizontalAxis.ClampValue(newValue);
        }
    }
}
