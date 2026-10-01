using System;
using UnityEngine;

namespace Camera
{
    public class LookAtCamera : MonoBehaviour
    {
        private enum Mode
        {
            LookAt,
            LookAtInverted,
            CameraForward,
            CameraForwardInverted
        }
        
        [SerializeField] private Mode mode = Mode.LookAt;

        private void LateUpdate()
        {
            switch (mode)
            {
                case Mode.LookAt:
                    transform.LookAt(UnityEngine.Camera.main.transform);
                    break;
                case Mode.LookAtInverted:
                    Vector3 directionFromCamera = transform.position - UnityEngine.Camera.main.transform.position;
                    transform.LookAt(transform.position + directionFromCamera);
                    break;
                case Mode.CameraForward:
                    transform.forward = UnityEngine.Camera.main.transform.forward;
                    break;
                case Mode.CameraForwardInverted:
                    transform.forward = -UnityEngine.Camera.main.transform.forward;
                    break;
            }
        }
    }
}
