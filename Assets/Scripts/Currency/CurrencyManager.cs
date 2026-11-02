using System;
using Nova;
using UnityEngine;


public class CurrencyManager : MonoBehaviour
{
    [SerializeField] private TextBlock currencyText;
    [SerializeField] private int startingBalance = 100;

    [Header("Passive Income")]
    [SerializeField] private float passiveIncomeAmount;
    [SerializeField] private float passiveIncomeInterval;

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

    private void Update()
    {
        PassiveIncome();
    }

    public void AddCurrency(int amount)
    {
        currentBalance += amount;
        BalanceChanged?.Invoke();
    }

    public bool TrySpend(int amount)
    {
        if (currentBalance < amount)
            return false;

        currentBalance -= amount;
        BalanceChanged?.Invoke();
        return true;
    }

    private void PassiveIncome()
    {
        timer += Time.deltaTime;
        if (timer < passiveIncomeInterval)
            return;

        int payments = Mathf.FloorToInt(timer / passiveIncomeInterval);
        timer -= payments * passiveIncomeInterval;
        AddCurrency(Mathf.FloorToInt(payments * passiveIncomeAmount));
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