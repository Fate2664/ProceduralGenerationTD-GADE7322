using System;
using DG.Tweening;
using Input;
using Nova;
using PCG;
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
        [SerializeField] private WorldGenerator worldGenerator;
        [SerializeField] private UIBlock2D deathMenuUI;
        
        private Tower tower;
        private bool isGameOver;
        
        public bool IsPaused {get ; private set;}

        private void Start()
        {
            deathMenuUI.transform.localScale = Vector3.zero;
            tower = worldGenerator.Tower.GetComponent<Tower>();
            tower.OnHealthChanged += HandleTowerHealthChanged;
            HandleTowerHealthChanged(tower.HealthPercentage);
        }

        private void HandleTowerHealthChanged(float percentage)
        {
            if (percentage <= 0f)
                ShowDeathMenu();
        }

        private void ShowDeathMenu()
        {
            if (isGameOver || deathMenuUI == null)
                return;

            isGameOver = true;
            IsPaused = true;
            Time.timeScale = 0f;

            if (pauseMenuUI != null)
            {
                pauseMenuUI.transform.DOKill();
                pauseMenuUI.transform.localScale = Vector3.zero;
            }

            if (pauseDimmer != null)
                pauseDimmer.BodyEnabled = true;

            deathMenuUI.gameObject.SetActive(true);
            deathMenuUI.transform.DOKill();
            deathMenuUI.transform.DOScale(1f, 0.5f).SetEase(Ease.OutBack).SetUpdate(true);
        }

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
