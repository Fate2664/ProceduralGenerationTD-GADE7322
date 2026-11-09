using UnityEngine;
using UnityEngine.InputSystem;

public class ScreenshotCapture : MonoBehaviour
{
    void Update()
    {
        if (Keyboard.current.backslashKey.wasPressedThisFrame)
        {
            ScreenCapture.CaptureScreenshot(
                "Screenshot.png",
                2
            );
        }
    }
}