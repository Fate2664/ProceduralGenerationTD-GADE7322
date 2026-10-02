using System.Collections.Generic;
using UnityEngine;

namespace PCG
{
    //This is a data class to hold the path profile data for each path
    public sealed class PathProfile
    {
        public Path Path { get; }
        
        public int Id => Path.Id;
        public Transform SpawnPoint => Path.SpawnPoint;
        public float Length => Path.Length;
        
        public int AdjacentBuildableTiles { get; }
        public int AdjacentDefenseCount { get; }    //Number of defenses adjacent to this path
        public float AdjacentDefenseRatio { get; } //Fraction of path tiles that have a defense adjacent to them

        public PathProfile(Path path, int adjacentBuildableTiles,
            int adjacentDefenseCount, float adjacentDefenseRatio)
        {
            Path = path;
            AdjacentBuildableTiles = adjacentBuildableTiles;
            AdjacentDefenseCount = adjacentDefenseCount;
            AdjacentDefenseRatio = Mathf.Clamp01(adjacentDefenseRatio);
        }

        //Estimated travel time depending on length of path
        public float EstimatedTravelTime(float moveSpeed) => Length / moveSpeed;
    }
}