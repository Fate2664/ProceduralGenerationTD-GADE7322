using TMPro;
using UnityEngine;


public class CurrencyManager : MonoBehaviour
{
    [SerializeField] private float startingBalance;

    [Header("Passive Income")] 
    [SerializeField] private float passiveIncomeAmount;
    [SerializeField] private float passiveIncomeInterval;

    [SerializeField] private TextMeshPro currencyText;

    public static CurrencyManager Instance; 

    public float currentBalance;
    private float timer;

    private void Awake()
    {
        Instance = this;
    }


    void Start()
    {
        currentBalance = startingBalance;   
        currencyText.text = currentBalance.ToString();
    }

    private void Update()
    {
        PassiveIncome();
    }

    public void AddCurrency(float amount)
    {
        currentBalance += amount;
        currencyText.text = currentBalance.ToString();

    }

    public bool TrySpend(float amount)
    {
        if (currentBalance < amount)
            return false;
        
        currentBalance -= amount;
        currencyText.text = currentBalance.ToString();
        
        return true;
    }

    private void PassiveIncome()
    {
        timer += Time.time;

        if (timer == passiveIncomeInterval)
        {
            timer = 0;
            AddCurrency(passiveIncomeAmount);
        }
    }


}
