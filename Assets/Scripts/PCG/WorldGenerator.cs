using System;
using System.Collections.Generic;
using System.Linq;
using Unity.AI.Navigation;
using UnityEngine;

namespace PCG
{
    //This script generates the level grid, obstacles, enemy paths, spawn points, and central tower
    public class WorldGenerator : MonoBehaviour
    {
        #region Serialized Fields

        [Header("Grid Settings")] 
        [SerializeField] private int gridSize = 31; //Must be odd number for there to be one center tile
        [SerializeField] private float gridOffset = 2f;
        [SerializeField] private NavMeshSurface navMeshSurface;

        [Header("Path Settings")] 
        [SerializeField] private int pathCount = 4;
        [SerializeField] private float turnChance = 0.35f;

        [Header("Spawning")]
        [SerializeField] private GameObject tilePrefab;
        [SerializeField] private GameObject pathPrefab;
        [SerializeField] private GameObject towerPrefab;
        [SerializeField] private float obstacleSpawnChance = 0.2f;

        [Header("Terrain Patches")] 
        [SerializeField] private int patchesPerTerrain = 2;
        [SerializeField] private int minPatchSize = 30;
        [SerializeField] private int maxPatchSize = 55;
        [SerializeField] private int terrainGap = 1;

        //Terrain effects
        [Header("Terrain Effects")] 
        [SerializeField] private float fertileProductionSpeedMultiplier = 1.5f;
        [SerializeField] private float desertEnemySpeedMultiplier = 1.25f;
        [SerializeField] private float rockyEnemyDamageMultiplier = 1.5f;

        //Terrain specific prefabs
        [Header("Terrain Prefabs")] 
        [SerializeField] private GridTile fertileSoilPrefab;
        [SerializeField] private GridTile desertPrefab;
        [SerializeField] private GridTile rockyGroundPrefab;
        [SerializeField] private GridTile rockyGroundPathPrefab;
        [SerializeField] private GridTile desertPathPrefab;
        [SerializeField] private GridTile fertileSoilPathPrefab;
        [SerializeField] private List<GridTile> fertileSoilObstaclePrefabs;
        [SerializeField] private List<GridTile> desertObstaclePrefabs;
        [SerializeField] private List<GridTile> rockyGroundObstaclePrefabs;
        [SerializeField] private List<GameObject> grasslandObstaclePrefabs;

        #endregion

        public float FertileProductionSpeedMultiplier => fertileProductionSpeedMultiplier;
        public float DesertEnemySpeedMultiplier => desertEnemySpeedMultiplier;
        public float RockyEnemyDamageMultiplier => rockyEnemyDamageMultiplier;
        public int GeneratedTerrainSeed { get; private set; }

        //Stores all the obstacle tiles
        private readonly List<GridTile> obstacleTiles = new();

        public float GridOffset => gridOffset;
        public float GridSize => gridSize;

        public GridTile[,] Grid { get; private set; }
        public List<Path> GeneratedPaths { get; private set; } //<-- This now returns the Path data type
        public Transform Tower { get; private set; }
        public Transform[] SpawnPoints { get; private set; }
        public bool IsGenerated { get; private set; }
        public List<GridTile> ObstacleTiles => obstacleTiles;

        public event Action Generated; //Action event to notify when everything in the world is generated

        void Awake()
        {
            GameObject[,] gameObjectGrid = GenerateGrid(); //Generate the base grid of tiles

            //Find walkable paths from the grid perimeter to its center
            PathGenerator pathGenerator = new PathGenerator(gameObjectGrid, turnChance);
            GeneratedPaths = pathGenerator.GeneratePaths(pathCount);

            //Replace the ordinary tiles in each route with path tiles
            ReplacePathTiles(gameObjectGrid);

            //Place tower in the center of the grid
            Tower = PlaceTowerAtCenter(gameObjectGrid);

            //Generate Terrains
            GenerateTerrain(gameObjectGrid);

            //First tile in a path becomes a spawn point
            SpawnPoints = GeneratedPaths.Select(path => path.SpawnPoint).ToArray();

            //Bake the nav mesh once everything is made
            navMeshSurface.BuildNavMesh();

            IsGenerated = true;
            Generated?.Invoke();
        }

        #region Terrain Generation

        //This method uses the TerrainRegionGenerator to replace original tiles with terrain tiles
        private void GenerateTerrain(GameObject[,] gameObjectGrid)
        {
            GeneratedTerrainSeed = UnityEngine.Random.Range(0, int.MaxValue);
            var generator = new TerrainRegionGenerator();
            generator.Generate(Grid, patchesPerTerrain, minPatchSize, maxPatchSize, terrainGap,
                new System.Random(GeneratedTerrainSeed));
            var replacements = new Dictionary<GridTile, GridTile>();

            for (int column = 0; column < Grid.GetLength(0); column++)
            {
                for (int row = 0; row < Grid.GetLength(1); row++)
                {
                    GridTile originalTile = Grid[column, row];

                    if (originalTile.Terrain == TerrainType.Grassland || originalTile.Occupant != null)
                        continue;

                    GridTile prefab = GetTerrainPrefab(originalTile.Terrain, originalTile.Type);
                    GridTile replacement = Instantiate(prefab, originalTile.transform.position,
                        originalTile.transform.rotation, transform);

                    replacement.Initialize(originalTile.Coordinates);
                    replacement.SetType(originalTile.Type);
                    replacement.SetTerrain(originalTile.Terrain);

                    if (originalTile.Type == TileType.Obstacle)
                    {
                        int obstacleIndex = obstacleTiles.IndexOf(originalTile);
                        if (obstacleIndex > 0)
                            obstacleTiles[obstacleIndex] = replacement;

                        replacement.name = "ObstacleTile(Clone)";
                    }

                    //Change layer mask if needed:
                    int tileLayer = originalTile.Type == TileType.Path
                        ? LayerMask.NameToLayer("Path")
                        : originalTile.gameObject.layer;

                    foreach (var child in replacement.GetComponentsInChildren<Transform>(true))
                    {
                        child.gameObject.layer = tileLayer;
                    }
                    
                    replacements.Add(originalTile, replacement);
                    Grid[column, row] = replacement;
                    gameObjectGrid[column, row] = replacement.gameObject;
                }
            }

            foreach (var path in GeneratedPaths)
            {
                for (int tileIndex = 0; tileIndex < path.TileCount; tileIndex++)
                {
                    if (replacements.TryGetValue(path.Tiles[tileIndex], out GridTile replacement))
                    {
                        path.ReplaceTile(tileIndex, replacement);
                    }
                }
            }

            foreach (var originalTile in replacements.Keys)
            {
                originalTile.gameObject.SetActive(false);
                Destroy(originalTile.gameObject);
            }

        }

        private GridTile GetTerrainPrefab(TerrainType terrain, TileType tileType)
        {
            if (tileType == TileType.Path)
            {
                return terrain switch
                {
                    TerrainType.FertileSoil => fertileSoilPathPrefab,
                    TerrainType.Desert => desertPathPrefab,
                    TerrainType.RockyGround => rockyGroundPathPrefab,
                    _ => null
                };
            }
            
            if (tileType == TileType.Obstacle)
                return GetTerrainObstaclePrefab(terrain);
            
            return terrain switch
            {
                TerrainType.FertileSoil => fertileSoilPrefab,
                TerrainType.Desert => desertPrefab,
                TerrainType.RockyGround => rockyGroundPrefab,
                _ => null
            };
        }

        private GridTile GetTerrainObstaclePrefab(TerrainType terrain)
        {
            List<GridTile> prefabs = terrain switch
            {
                TerrainType.FertileSoil => fertileSoilObstaclePrefabs,
                TerrainType.Desert => desertObstaclePrefabs,
                TerrainType.RockyGround => rockyGroundObstaclePrefabs,
                _ => null
            };

            int prefabIndex = UnityEngine.Random.Range(0, prefabs.Count);
            return prefabs[prefabIndex];
        }
        
        #endregion
        
        public bool TryGetTile(Vector3 worldPosition, out GridTile tile)
        {
            tile = null;
            Vector3 offset = worldPosition - transform.position;
            float halfGridSize = (gridSize - 1) * gridOffset * 0.5f;
            int column = Mathf.FloorToInt((offset.x + halfGridSize) / gridOffset + 0.5f);
            int row = Mathf.FloorToInt((offset.z + halfGridSize) / gridOffset + 0.5f);

            if (column < 0 || column >= Grid.GetLength(0) || row < 0 || row >= Grid.GetLength(1))
                return false;

            tile = Grid[column, row];
            return tile != null;
        }

        //This method places the tower on the grid's center tile 
        private Transform PlaceTowerAtCenter(GameObject[,] grid)
        {
            int centerX = grid.GetLength(0) / 2;
            int centerZ = grid.GetLength(1) / 2;
            Vector3 centerPos = grid[centerX, centerZ].transform.position;
            Transform tower = Instantiate(towerPrefab, centerPos, Quaternion.identity, transform).transform;

            GridTile centerTile = Grid[centerX, centerZ];
            centerTile.SetType(TileType.Obstacle);
            centerTile.SetOccupant(tower.gameObject);

            return tower;
        }

        //This method creates the grid and randomly replaces ordinary tiles with obstacle tiles
        private GameObject[,] GenerateGrid()
        {
            //Gameobjects are used during path generation, while GridTiles store tile data
            GameObject[,] gameObjectGrid = new GameObject[gridSize, gridSize];
            Grid = new GridTile[gridSize, gridSize];

            obstacleTiles.Clear();

            //Offset the spawning of the grid so the center is aligned with the game object's transform
            float halfGridSize = (gridSize - 1) * gridOffset * 0.5f;

            int center = gridSize / 2;

            for (int x = 0; x < gridSize; x++)
            {
                for (int z = 0; z < gridSize; z++)
                {
                    Vector3 localOffset = new Vector3(x * gridOffset - halfGridSize, 0f, z * gridOffset - halfGridSize);
                    Vector3 worldPosition = transform.position + localOffset;

                    //Center must remain available
                    bool isCenterTile = x == center && z == center;
                    bool spawnObstacle = !isCenterTile && UnityEngine.Random.value < obstacleSpawnChance;

                    GameObject selectedPrefab = tilePrefab;

                    //select obstacle
                    if (spawnObstacle)
                    {
                        int prefabIndex = UnityEngine.Random.Range(0, grasslandObstaclePrefabs.Count);
                        selectedPrefab = grasslandObstaclePrefabs[prefabIndex];
                    }

                    //Random rotation
                    float randomYRotation = UnityEngine.Random.Range(0, 4) * 90f;
                    Quaternion rotation = Quaternion.Euler(0f, randomYRotation, 0f);

                    GameObject tile = Instantiate(selectedPrefab, worldPosition, rotation, transform);
                    GridTile gridTile = tile.GetComponent<GridTile>();

                    //Give the tile its grid coordinates once spawned
                    gridTile.Initialize(new Vector2Int(x, z));

                    if (spawnObstacle)
                    {
                        gridTile.SetType(TileType.Obstacle);
                        obstacleTiles.Add(gridTile);
                        tile.name = "ObstacleTile(Clone)";
                    }

                    gameObjectGrid[x, z] = tile;
                    Grid[x, z] = gridTile;
                }
            }

            return gameObjectGrid;
        }

        #region Path Generation

        //This method replaces every ordinary tile inside of a path to the path tile
        private void ReplacePathTiles(GameObject[,] gameObjectGrid)
        {
            Dictionary<GridTile, GridTile> replacements = new();

            //Create a replacement for every unique path tile
            foreach (Path path in GeneratedPaths)
            {
                foreach (GridTile tile in path.Tiles)
                {
                    //Multiple paths can share the same tile so skip them
                    if (replacements.ContainsKey(tile))
                        continue;

                    GridTile gridTile = tile.GetComponent<GridTile>();
                    Vector2Int coordinates = gridTile.Coordinates;

                    GameObject newTile = Instantiate(pathPrefab, tile.transform.position, tile.transform.rotation,
                        transform);
                    GridTile newGridTile = newTile.GetComponent<GridTile>();
                    newGridTile.Initialize(coordinates);
                    newGridTile.SetType(TileType.Path);
                    newTile.name = "PathTile(Clone)";

                    //Apply path layer to all objects in path tile
                    newTile.layer = LayerMask.NameToLayer("Path");

                    replacements.Add(tile, newGridTile);

                    //Update both grid representations to point to the new path tile
                    gameObjectGrid[coordinates.x, coordinates.y] = newTile;
                    Grid[coordinates.x, coordinates.y] = newGridTile;
                }
            }

            foreach (Path path in GeneratedPaths)
            {
                for (int i = 0; i < path.TileCount; i++)
                {
                    GridTile replacement = replacements[path.Tiles[i]];
                    path.ReplaceTile(i, replacement);
                }
            }

            //Remove original tiles
            foreach (GridTile originalTile in replacements.Keys)
            {
                originalTile.gameObject.SetActive(false);
                Destroy(originalTile.gameObject);
            }
        }

        //This method finds the generated path associated with a particular spawn point
        public Path GetPathForSpawnPoint(Transform spawnPoint)
        {
            foreach (Path path in GeneratedPaths)
            {
                if (path.SpawnPoint == spawnPoint)
                    return path;
            }

            return null;
        }

        //This method finds the path tile closest to a given position in the world
        public Transform GetClosestPathTile(Vector3 worldPosition)
        {
            Transform closestTile = null;
            float closestDistanceSquared = float.PositiveInfinity;

            foreach (GridTile tile in Grid)
            {
                if (tile.Type != TileType.Path)
                    continue;

                Vector3 offset = tile.transform.position - worldPosition;
                offset.y = 0f;

                if (offset.sqrMagnitude >= closestDistanceSquared)
                    continue;

                closestDistanceSquared = offset.sqrMagnitude;
                closestTile = tile.transform;
            }

            return closestTile;
        }

        #endregion
    }
}