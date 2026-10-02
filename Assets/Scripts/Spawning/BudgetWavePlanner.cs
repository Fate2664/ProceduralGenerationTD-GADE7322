using System.Collections.Generic;
using Enemy;
using PCG;
using UnityEngine;
using UnityEngine.Audio;

namespace Spawning
{
    //This class builds a wave planner by selecting weighted enemy and path combinations within a threat budget
    public sealed class BudgetWavePlanner
    {
        //This represents one possible enemy and path combination with its selection weight
        private struct Candidate
        {
            public EnemyData Enemy;
            public int PathIndex;  
            public float Weight;
        }

        public WavePlan CreatePlan(int waveNumber, int budget, IReadOnlyList<EnemyData> enemyTypes,
            IReadOnlyList<PathProfile> paths, System.Random random, int maxEnemies)
        {
            var instructions = new List<SpawnInstruction>();
            int remainingBudget = budget;
            int[] allocatedThreat = new int [paths.Count];  //Tracks how much threat has already been assigned to each path in this plan
            int previousPath = -1;
            float averageLength = 0f;
            
            //Calculate the average path length so each path can be weighted relative to others
            foreach(PathProfile path in paths)
                averageLength += path.Length;

            averageLength = averageLength / paths.Count;
            var candidates = new List<Candidate>();

            //Keep selecting enemies while budget remains and below max enemies
            while (remainingBudget > 0 && instructions.Count < maxEnemies)
            {
                candidates.Clear();
                float totalWeight = 0f;

                foreach (EnemyData enemy in enemyTypes)
                {
                    //Skip enemies that have not been unlocked or are above the remaining budget
                    if (enemy.UnlockWave > waveNumber || enemy.ThreatCost > remainingBudget)
                        continue;

                    for (int i = 0; i < paths.Count; i++)
                    {
                        PathProfile path = paths[i];
                        float allocationWeight = 1f / (1f + allocatedThreat[i]);
                        
                        //Discourage repeatedly using the same entrance
                        float repetitionWeight = i == previousPath ? 0.5f : 1f;
                        //Shorter paths recieve less weight
                        float lengthWeight = Mathf.Clamp(path.Length / averageLength, 0.5f, 1.5f);
                        
                        //Get total weighting
                        float weight = enemy.SelectionWeight * GetTypeWeight(enemy.Type, path) * allocationWeight * repetitionWeight * lengthWeight;

                        candidates.Add(new Candidate
                        {
                            Enemy = enemy,
                            PathIndex = i,
                            Weight = weight
                        });

                        totalWeight += weight;
                    }
                }
                
                if (candidates.Count == 0 || totalWeight <= 0f)
                    break;
                
                //Randomly select a candidate
                double roll = random.NextDouble() * totalWeight;
                Candidate selected = candidates[candidates.Count - 1];

                foreach (var candidate in candidates)
                {
                    //Larger weights occupy more of the selection range
                    roll -= candidate.Weight;

                    if (roll <= 0)
                    {
                        selected = candidate;
                        break;
                    }
                }
                
                instructions.Add(new SpawnInstruction(selected.Enemy, paths[selected.PathIndex]));
                
                //Spend the selected enemy's cost and update threat assigned to its path
                remainingBudget -= selected.Enemy.ThreatCost;   
                allocatedThreat[selected.PathIndex] += selected.Enemy.ThreatCost;
                previousPath = selected.PathIndex;
            }
            
            return new WavePlan(budget, budget - remainingBudget, instructions);
        }

        //Adjust the enemy's suitability according to the defenses adjacent to this path
        private static float GetTypeWeight(EnemyType type, PathProfile path)
        {

            switch (type)
            {
                //Common enemies have no preference based on adjacent defenders
                case EnemyType.Common:
                    return 1f;
                //Swarmer enemies favour more adjacent defenders - multiplier capped at 4
                case EnemyType.Swarmer:
                    return 1f + 0.15f * Mathf.Min(path.AdjacentDefenseCount, 4);
                //Ranger enemies prefer paths with a higher proportion of tiles with defenders
                case EnemyType.Ranger:
                    return Mathf.Lerp(0.75f, 1.25f, path.AdjacentDefenseRatio);
                
                default: return 1f;
            }
        }
    }
}