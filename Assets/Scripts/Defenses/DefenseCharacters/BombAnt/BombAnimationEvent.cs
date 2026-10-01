using UnityEngine;

namespace Defenses.DefenseCharacters.BombAnt
{
    public class BombAnimationEvent : MonoBehaviour
    {
        private BombDefenseCharacter character;

        private void Awake()
        {
            character = GetComponentInParent<BombDefenseCharacter>();
        }

        public void ReleaseBomb()
        {
            character.ReleaseBomb();
        }

        public void RestoreHeldBomb()
        {
            character.RestoreHeldBomb();
        }
    }
}