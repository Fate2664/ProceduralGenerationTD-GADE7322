using System;
using DG.Tweening;
using Enemy;
using Menu;
using UnityEngine;
using UnityEngine.InputSystem;

public class TutorialManager : MonoBehaviour
{
    [SerializeField] private Transform tutorialRoot;
    [SerializeField] private Transform contentRoot;
    [SerializeField] private EnemyWaveManager waveManager;
    [SerializeField] private MenuManager menuManager;

    private GameObject[] pages;
    private Tween scaleTween;
    private int currentPage;
    private bool isTransitioning;
    private bool isOpen;
    private bool waveManagerWasEnabled;
    private bool menuManagerWasEnabled;

    private void Awake()
    {
        pages = new GameObject[contentRoot.childCount];

        for (int index = 0; index < pages.Length; index++)
        {
            pages[index] = contentRoot.GetChild(index).gameObject;
            pages[index].SetActive(index == 0);
        }

        waveManagerWasEnabled = waveManager.enabled;
        menuManagerWasEnabled = menuManager.enabled;

        waveManager.enabled = false;
        menuManager.enabled = false;
        Time.timeScale = 0f;

        isOpen = true;
        isTransitioning = false;
    }

    private void Update()
    {
        if (!isOpen || isTransitioning || Keyboard.current == null)
            return;

        if (!Keyboard.current.eKey.wasPressedThisFrame)
            return;

        if (currentPage < pages.Length - 1)
        {
            pages[currentPage].SetActive(false);
            currentPage++;
            pages[currentPage].SetActive(true);
            return;
        }

        CloseTutorial();
    }

    private void CloseTutorial()
    {
        isTransitioning = true;
        scaleTween?.Kill();
        
        scaleTween = tutorialRoot.DOScale(0f, 0.35f).SetEase(Ease.OutCubic).SetUpdate(true).OnComplete(() =>
        {
            ResumeGame();
            tutorialRoot.gameObject.SetActive(false);
        });
    }

    private void ResumeGame()
    {
        if (!isOpen)
            return;
        
        isOpen = false;
        Time.timeScale = 1f;
        waveManager.enabled = true;
        menuManager.enabled = true;
    }

    private void OnDisable()
    {
        scaleTween?.Kill();
        ResumeGame();
    }
}