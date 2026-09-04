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
        [SerializeField] private List<GameObject> obstaclePrefabs;
        [SerializeField] private float obstacleSpawnChance = 0.2f;

        //Stores all the obstacle tiles
        private readonly List<GridTile> obstacleTiles = new();
        
        public float GridOffset => gridOffset;
        public float GridSize => gridSize;
        
        public GridTile[,] Grid { get; private set; }
        public List<List<GameObject>> GeneratedPaths { get; private set; }
        public Transform Tower { get; private set; }
        public Transform[] SpawnPoints { get; private set; }
        public bool IsGenerated { get; private set; }
        public List<GridTile> ObstacleTiles => obstacleTiles;
        
        public event Action Generated;  //Action event to notify when everything in the world is generated
        
        void Awake()
        {
            GameObject[,] gameObjectGrid = GenerateGrid();  //Generate the base grid of tiles
            
            //Find walkable paths from the grid perimeter to its center
            Path pathGenerator = new Path(gameObjectGrid, turnChance);
            GeneratedPaths = pathGenerator.GeneratePaths(pathCount);

            //Replace the ordinary tiles in each route with path tiles
            ReplacePathTiles(gameObjectGrid);
            
            //First tile in a path becomes a spawn point
            SpawnPoints = GeneratedPaths.Select(path => path[0].transform).ToArray();
            //Place tower in the center of the grid
            Tower = PlaceTowerAtCenter(gameObjectGrid);
            //Bake the nav mesh once everything is made
            navMeshSurface.BuildNavMesh();
            
            IsGenerated = true;
            Generated?.Invoke();
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
                        int prefabIndex = UnityEngine.Random.Range(0, obstaclePrefabs.Count);
                        selectedPrefab = obstaclePrefabs[prefabIndex];
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

        //This method replaces every ordinary tile inside of a path to the path tile
        private void ReplacePathTiles(GameObject[,] gameObjectGrid)
        {
            Dictionary<GameObject, GameObject> replacements = new();
            
            //Create a replacement for every unique path tile
            foreach (List<GameObject> route in GeneratedPaths)
            {
                foreach (GameObject tile in route)
                {
                    //Multiple paths can share the same tile so skip them
                    if (replacements.ContainsKey(tile))
                        continue;
                    
                    GridTile gridTile = tile.GetComponent<GridTile>();
                    Vector2Int coordinates = gridTile.Coordinates;
                    
                    GameObject newTile = Instantiate(pathPrefab, tile.transform.position, tile.transform.rotation, transform);
                    GridTile newGridTile = newTile.GetComponent<GridTile>();
                    newGridTile.Initialize(coordinates);
                    newGridTile.SetType(TileType.Path);
                    newTile.name = "PathTile(Clone)";
                    
                    //Apply path layer to all objects in path tile
                    newTile.layer = LayerMask.NameToLayer("Path");
                    
                    replacements.Add(tile, newTile);
                    
                    //Update both grid representations to point to the new path tile
                    gameObjectGrid[coordinates.x, coordinates.y] = newTile;
                    Grid[coordinates.x, coordinates.y] = newGridTile;
                }
            }

            foreach (var route in GeneratedPaths)
            {
                for (int i = 0; i < route.Count; i++)
                {
                    route[i] = replacements[route[i]];
                }
            }
            
            //Remove original tiles
            foreach (GameObject tile in replacements.Keys)
                Destroy(tile);
        }
        
        //This method finds the generated path associated with a particular spawn point
        public List<GameObject> GetPathForSpawnPoint(Transform spawnPoint)
        {
            foreach (List<GameObject> path in GeneratedPaths)
                if (path.Count > 0 && path[0].transform == spawnPoint)
                    return path;

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
    }
}