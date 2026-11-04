using System;
using Nova;
using UnityEngine;


public class CurrencyManager : MonoBehaviour
{
    [SerializeField] private TextBlock currencyText;
    [SerializeField] private int startingBalance = 100;

    public static CurrencyManager Instance;

    private int currentBalance;
    private float timer;

    public int CurrentBalance => currentBalance;
    public event Action BalanceChanged;

    private void Awake()
    {
        Instance = this;
        currentBalance = startingBalance;
    }


    void Start()
    {
        BalanceChanged?.Invoke();
    }

    private void OnEnable()
    {
        BalanceChanged += UpdateCurrencyText;
        UpdateCurrencyText();
    }

    public void AddCurrency(int amount)
    {
        currentBalance += amount;
        BalanceChanged?.Invoke();
    }

    public bool TrySpend(int amount)
    {
        if (amount < 0 || currentBalance < amount)
            return false;

        currentBalance -= amount;
        BalanceChanged?.Invoke();
        return true;
    }

    private void UpdateCurrencyText()
    {
        currencyText.Text = CurrentBalance.ToString("0");
    }

    private void OnDisable()
    {
        BalanceChanged -= UpdateCurrencyText;
    }
}