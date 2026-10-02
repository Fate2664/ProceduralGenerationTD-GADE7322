using System.Collections.Generic;
using Defenses.DefenseCharacters;
using NUnit.Framework;
using PCG;
using UnityEngine;
using UnityEngine.WSA;

namespace PCG
{
    //This class creates a Path Profile for each path
    public static class PathAnalyzer
    {
        private static readonly Vector2Int[] Directions =
        {
            Vector2Int.up,
            Vector2Int.down,
            Vector2Int.left,
            Vector2Int.right
        };

        public static List<PathProfile> BuildProfiles(WorldGenerator world)
        {
            var profiles = new List<PathProfile>();
            if (!world.IsGenerated || world.GeneratedPaths == null) return profiles;
            
            GridTile[,] grid = world.Grid;

            foreach (Path path in world.GeneratedPaths)
            {
                var buildableTiles = new HashSet<GridTile>();       //Buildable tiles 
                var defenses = new HashSet<DefenseCharacterBase>(); //Number of defenses

                int coveredTiles = 0;

                foreach (GridTile pathTile in path.Tiles)
                {
                    bool hasAdjacentDefense = false;

                    foreach (Vector2Int direction in Directions)
                    {
                        Vector2Int position = pathTile.Coordinates + direction;

                        if (position.x < 0 || position.y < 0 || position.x >= grid.GetLength(0) ||
                            position.y >= grid.GetLength(1)) continue;
                        
                        GridTile neighbour = grid[position.x, position.y];
                        
                        if (neighbour == null) continue;
                        
                        if (neighbour.Type == TileType.Buildable)
                            buildableTiles.Add(neighbour);

                        if (neighbour.Occupant != null &&
                            neighbour.Occupant.TryGetComponent(out DefenseCharacterBase defenseCharacter))
                        {
                            defenses.Add(defenseCharacter);
                            hasAdjacentDefense = true;
                        }
                    }
                    if (hasAdjacentDefense)
                        coveredTiles++; //increment covered tiles that have an adjacent defense
                }
                
                //Covered tiles / path tile count = adjacent defense ratio
                profiles.Add(new PathProfile(path, buildableTiles.Count, defenses.Count, coveredTiles / (float)path.TileCount));
            }
            return profiles;
        }
    }
}