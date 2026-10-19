using UnityEngine;

public class CurrencyManager : MonoBehaviour
{
    [SerializeField] private float startingBalance;

    [Header("Passive Income")] 
    [SerializeField] private float passiveIncomeAmount;
    [SerializeField] private float passiveIncomeInterval;

    public float currentBalance;
    private float timer;


    void Start()
    {
        currentBalance = startingBalance;   
    }

    private void Update()
    {
        PassiveIncome();
    }

    private void AddCurrency(float Amount)
    {
        currentBalance += Amount;   
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
