using System.Collections.Generic;
using UnityEngine;

namespace PCG
{
    //All terrain types
    public enum TerrainType
    {
        Grassland,
        FertileSoil,
        Desert,
        RockyGround
    }

    public class TerrainRegionGenerator
    {
        //Directions that the patch can grow
        private static readonly Vector2Int[] directions =
        {
            Vector2Int.up, Vector2Int.down, Vector2Int.left, Vector2Int.right
        };

        private static readonly TerrainType[] terrainTypes =
        {
            TerrainType.FertileSoil, TerrainType.Desert, TerrainType.RockyGround
        };

        public void Generate(GridTile[,] grid, int patchesPerTerrain, int minPatchSize, int maxPatchSize,
            int terrainGap,
            System.Random random)
        {
            //Set all tiles to grassland tiles
            foreach (var tile in grid)
                tile.SetTerrain(TerrainType.Grassland);

            //Min and max values that are inside the grid's bounds
            int minimum = Mathf.Clamp(minPatchSize, 1, grid.Length);
            int maximum = Mathf.Clamp(maxPatchSize, minimum, grid.Length);

            for (int patchIndex = 0; patchIndex < patchesPerTerrain; patchIndex++)
            {
                int terrainOffset = random.Next(terrainTypes.Length);

                for (int terrainIndex = 0; terrainIndex < terrainTypes.Length; terrainIndex++)
                {
                    TerrainType terrain = terrainTypes[(terrainOffset + terrainIndex) % terrainTypes.Length];
                    //Start fertile soil on a buidable tile while the others on path tiles
                    TileType requiredType = terrain == TerrainType.FertileSoil ? TileType.Buildable : TileType.Path;
                    var candidates = new List<GridTile>();
    
                    //Collect valid starting tiles 
                    foreach (var tile in grid)
                    {
                        if (tile.Type == requiredType && CanUseTile(grid, tile.Coordinates, terrainGap))
                            candidates.Add(tile);
                    }
                    
                    //Choose a random target size within the defined range
                    int targetSize = random.Next(minimum, maximum + 1);
                    bool placed = false;
                    int attempts = Mathf.Min(30, candidates.Count);

                    for (int attempt = 0; attempt < attempts; attempt++)
                    {
                        int candidateIndex = random.Next(candidates.Count);
                        GridTile seed = candidates[candidateIndex];
                        candidates.RemoveAt(candidateIndex);
                        
                        List<GridTile> patch = GrowPatch(grid, seed, targetSize, terrainGap, random);
                        
                        //Continue to grow if the minimum is not reached
                        if (patch.Count < minimum)
                            continue;
                        
                        //Apply the terrain tile to the set terrain type
                        foreach (var tile in patch)
                            tile.SetTerrain(terrain);
                        
                        placed = true;
                        break;
                    }
                }
                
            }
        }

        private static List<GridTile> GrowPatch(GridTile[,] grid, GridTile seed, int targetSize, int terrainGap, System.Random random)
        {
            var patch =  new List<GridTile>();  //Accepted tiles
            var frontier = new List<Vector2Int>();  //Possible expansion tiles
            var visited = new HashSet<Vector2Int>();    //All visited tiles
            var scores = new Dictionary<Vector2Int, float>();   //Growth scores

            AddCandidate(seed.Coordinates);

            //Expand until the target size is reached
            while (frontier.Count > 0 & patch.Count < targetSize)
            {
                //Select the candidate with the lowest score
                int bestIndex = 0;
                float bestScore = scores[frontier[0]];

                for (int candidateIndex = 1; candidateIndex < frontier.Count; candidateIndex++)
                {
                    float score = scores[frontier[candidateIndex]];

                    if (score < bestScore)
                    {
                        bestScore = score;
                        bestIndex = candidateIndex;
                    }
                }
                
                Vector2Int coordnates = frontier[bestIndex];
                frontier.RemoveAt(bestIndex);
                
                patch.Add(grid[coordnates.x, coordnates.y]);
                
                //Add valid neighbour tiles as candidates
                foreach (var direction in directions)
                    AddCandidate(coordnates + direction);
            }
            return patch;
            
            void AddCandidate(Vector2Int coordnates)
            {
                //Skip positions already visited or unusable
                if (!visited.Add(coordnates) || !CanUseTile(grid, coordnates, terrainGap))
                    return;
                
                //Combine distance from starting tile with random variation
                Vector2Int offset = coordnates - seed.Coordinates;
                float distanceSquared = offset.sqrMagnitude;
                float variation = (float)random.NextDouble() * 2f;
                
                scores.Add(coordnates, distanceSquared + variation);
                frontier.Add(coordnates);
            }
        }

        private static bool CanUseTile(GridTile[,] grid, Vector2Int coordnates, int terrainGap)
        {
            int width = grid.GetLength(0);
            int height = grid.GetLength(1);
            
            //Check bounds
            if (coordnates.x < 0 || coordnates.x >= width || coordnates.y < 0 || coordnates.y >= height)
                return false;
            
            GridTile tile = grid[coordnates.x, coordnates.y];
            
            if (tile.Occupant != null || tile.Terrain != TerrainType.Grassland)
                return false;

            int firstColumn = Mathf.Max(0, coordnates.x - terrainGap);
            int lastColumn = Mathf.Min(width - 1, coordnates.x + terrainGap);
            int firstRow = Mathf.Max(0, coordnates.y - terrainGap);
            int lastRow = Mathf.Min(height - 1, coordnates.y + terrainGap);

            for (int column = firstColumn; column <= lastColumn; column++)
            {
                for (int row = firstRow; row <= lastRow; row++)
                {
                    if (grid[column, row].Terrain != TerrainType.Grassland)
                        return false;
                }
            }

            return true;
        }
    }
}