using Nova;
using Systems;
using UnityEngine;

namespace Defenses
{
    [CreateAssetMenu(menuName = "Defenses/DefenseOption")]
    public class DefenseOptionData : EntityData
    {
        [field: SerializeField] public Sprite Icon {get; private set;}
        //[field: SerializeField] public int Cost {get; private set;}
    }
}