using System;
using UnityEngine;

namespace Defenses.DefenseCharacters.MeleeAnt
{
    public class MeleeAnimationEvent : MonoBehaviour
    {
        private MeleeDefenseCharacter character;

        private void Awake()
        {
            character = GetComponentInParent<MeleeDefenseCharacter>();
        }

        public void MeleeHit()
        {
            if (character != null)
                character.MeleeHit();
        }
    }
}