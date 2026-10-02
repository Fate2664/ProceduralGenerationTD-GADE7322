using System.Collections.Generic;
using Enemy;
using PCG;

namespace Spawning
{
    //This class stores the enemy type and path in question for one spawn
    public sealed class SpawnInstruction
    {
        public EnemyData Enemy { get; }
        public PathProfile PathProfile { get; }

        public SpawnInstruction(EnemyData enemy, PathProfile pathProfile)
        {
            Enemy = enemy;
            PathProfile = pathProfile;
        }
    }
    
    //This class stores the generated spawn instructions and threat budget for one wave
    public sealed class WavePlan
    {
        public int Budget { get; }
        public int SpentBudget { get; }
        public int UnspendBudget => Budget - SpentBudget;       //The budget remaining after selecting the enemies for this wave
        
        public IReadOnlyList<SpawnInstruction> Instructions { get; }    //The order in which the enemies will spawn

        public WavePlan(int budget, int spentBudget, List<SpawnInstruction> instructions)
        {
            Budget = budget;
            SpentBudget = spentBudget;
            Instructions = instructions;
        }
        
    }
}