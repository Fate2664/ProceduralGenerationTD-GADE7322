using System.Collections.Generic;
using Enemy;
using PCG;
using UnityEngine;
using UnityEngine.Audio;

namespace Spawning
{
    public sealed class BudgetWavePlanner
    {
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
            int[] allocatedThreat = new int [paths.Count];
            int previousPath = -1;
            float averageLength = 0f;
            
            foreach(PathProfile path in paths)
                averageLength += path.Length;

            averageLength = averageLength / paths.Count;
            var candidates = new List<Candidate>();

            while (remainingBudget > 0 && instructions.Count < maxEnemies)
            {
                candidates.Clear();
                float totalWeight = 0f;

                foreach (EnemyData enemy in enemyTypes)
                {
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
                
                double roll = random.NextDouble() * totalWeight;
                Candidate selected = candidates[candidates.Count - 1];

                foreach (var candidate in candidates)
                {
                    roll -= candidate.Weight;

                    if (roll <= 0)
                    {
                        selected = candidate;
                        break;
                    }
                }
                
                instructions.Add(new SpawnInstruction(selected.Enemy, paths[selected.PathIndex]));
                remainingBudget -= selected.Enemy.ThreatCost;
                allocatedThreat[selected.PathIndex] += selected.Enemy.ThreatCost;
                previousPath = selected.PathIndex;
            }
            
            return new WavePlan(budget, budget - remainingBudget, instructions);
        }

        private static float GetTypeWeight(EnemyType type, PathProfile path)
        {

            switch (type)
            {
                case EnemyType.Common:
                    return 1f;
                
                case EnemyType.Swarmer:
                    return 1f + 0.15f * Mathf.Min(path.AdjacentDefenseCount, 4);
                
                case EnemyType.Ranger:
                    return Mathf.Lerp(0.75f, 1.25f, path.AdjacentDefenseRatio);
                
                default: return 1f;
            }
        }
    }
}