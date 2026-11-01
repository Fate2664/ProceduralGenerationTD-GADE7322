using System;
using UnityEngine;


public class CurrencyManager : MonoBehaviour
{
    [SerializeField] private float startingBalance;

    [Header("Passive Income")] [SerializeField]
    private float passiveIncomeAmount;

    [SerializeField] private float passiveIncomeInterval;

    public static CurrencyManager Instance;

    private float currentBalance;
    private float timer;

    public float CurrentBalance => currentBalance;
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

    private void Update()
    {
        PassiveIncome();
    }

    public void AddCurrency(float amount)
    {
        currentBalance += amount;
        BalanceChanged?.Invoke();
    }

    public bool TrySpend(float amount)
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
        AddCurrency(payments * passiveIncomeAmount);
    }
}