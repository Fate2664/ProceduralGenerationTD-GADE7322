using System.Collections.Generic;
using UnityEngine;

namespace PCG
{
    public sealed class PathProfile
    {
        public Path Path { get; }
        
        public int Id => Path.Id;
        public Transform SpawnPoint => Path.SpawnPoint;
        public float Length => Path.Length;
        
        public int AdjacentBuildableTiles { get; }
        public int AdjacentDefenseCount { get; }
        public float AdjacentDefenseRatio { get; } //Fraction of path tiles that have a defense adjacent to them

        public PathProfile(Path path, int adjacentBuildableTiles,
            int adjacentDefenseCount, float adjacentDefenseRatio)
        {
            AdjacentBuildableTiles = adjacentBuildableTiles;
            AdjacentDefenseCount = adjacentDefenseCount;
            AdjacentDefenseRatio = Mathf.Clamp01(adjacentDefenseRatio);
        }

        public float EstimatedTravelTime(float moveSpeed) => Length / moveSpeed;
    }
}