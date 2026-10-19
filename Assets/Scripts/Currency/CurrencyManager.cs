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

    public void AddCurrency(float Amount)
    {
        currentBalance += Amount;
        currencyText.text = currentBalance.ToString();

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
