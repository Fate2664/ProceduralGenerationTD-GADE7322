using System;
using DG.Tweening;
using Input;
using Nova;
using UnityEngine;
using UnityEngine.Events;
using UnityEngine.SceneManagement;

namespace Menu
{
    public class MenuManager : MonoBehaviour
    {
        [SerializeField] private UIBlock2D pauseMenuUI;
        [SerializeField] private UIBlock2D pauseDimmer;
        [SerializeField] private GameInput input;
        
        public bool IsPaused {get ; private set;}

        private void OnEnable()
        {
            input.Pause += OnPause;
        }

        private void OnDisable()
        {
            input.Pause -= OnPause;
        }

        private void OnPause(bool pressed)
        {
            if (pressed)
                TogglePauseMenu();
        }

        public void Restart()
        {
            Time.timeScale = 1f;
            
            SceneManager.LoadScene(SceneManager.GetActiveScene().name);
        }

        public void Continue()
        {
            HidePauseMenu();
        }

        public void ShowPauseMenu()
        {
            if (pauseMenuUI == null) return;

            IsPaused = true;
            Time.timeScale = 0f;

            pauseDimmer.BodyEnabled = true;

            pauseMenuUI.transform.DOKill();
            pauseMenuUI.transform.DOScale(1f, .5f).SetEase(Ease.OutBack).SetUpdate(true);
        }

        public void HidePauseMenu()
        {
            if (pauseMenuUI == null) return;
            
            IsPaused = false;
            Time.timeScale = 1f;
            
            pauseDimmer.BodyEnabled = false;

            pauseMenuUI.transform.DOKill();
            pauseMenuUI.transform.DOScale(0f, .3f).SetEase(Ease.OutQuad).SetUpdate(true);
        }
        
        public void TogglePauseMenu()
        {
            if (IsPaused)
                HidePauseMenu();
            else
                ShowPauseMenu();
        }
    }
}
