using System;
using UnityEngine;

namespace Defenses.DefenseCharacters
{
    public class SpearAnimationEvent : MonoBehaviour
    {
        private SpearDefenseCharacter character;

        private void Awake()
        {
            character = GetComponentInParent<SpearDefenseCharacter>();
        }
        
        public void ReleaseSpear()
        {
            character.ReleaseSpear();
        }

        public void RestoreHeldSpear()
        {
            character.RestoreHeldSpear();
        }
    }
}