using System.Collections.Generic;
using Enemy;
using PCG;

namespace Spawning
{
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
    
    public sealed class WavePlan
    {
        public int Budget { get; }
        public int SpentBudget { get; }
        public int UnspendBudget => Budget - SpentBudget;
        
        public IReadOnlyList<SpawnInstruction> Instructions { get; }

        public WavePlan(int budget, int spentBudget, List<SpawnInstruction> instructions)
        {
            Budget = budget;
            SpentBudget = spentBudget;
            Instructions = instructions;
        }
        
    }
}