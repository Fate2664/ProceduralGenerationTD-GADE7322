using System;
using System.Collections.Generic;
using System.Linq;
using Unity.AI.Navigation;
using UnityEngine;

namespace PCG
{
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

        private readonly List<GridTile> obstacleTiles = new();
        
        public float GridOffset => gridOffset;
        public float GridSize => gridSize;
        
        public GridTile[,] Grid { get; private set; }
        public List<List<GameObject>> GeneratedPaths { get; private set; }
        public Transform Tower { get; private set; }
        public Transform[] SpawnPoints { get; private set; }
        public bool IsGenerated { get; private set; }
        public List<GridTile> ObstacleTiles => obstacleTiles;
        
        public event Action Generated;
        
        void Awake()
        {
            GameObject[,] gameObjectGrid = GenerateGrid();
            Path pathGenerator = new Path(gameObjectGrid, turnChance);
            GeneratedPaths = pathGenerator.GeneratePaths(pathCount);

            ReplacePathTiles(gameObjectGrid);
            SpawnPoints = GeneratedPaths.Select(path => path[0].transform).ToArray();
            Tower = PlaceTowerAtCenter(gameObjectGrid);
            navMeshSurface.BuildNavMesh();
            
            IsGenerated = true;
            Generated?.Invoke();
        }

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

        private GameObject[,] GenerateGrid()
        {
            GameObject[,] gameObjectGrid = new GameObject[gridSize, gridSize];
            Grid = new GridTile[gridSize, gridSize];
            
            obstacleTiles.Clear();
            
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
                    
                    //Random rotation:
                    float randomYRotation = UnityEngine.Random.Range(0, 4) * 90f;
                    Quaternion rotation = Quaternion.Euler(0f, randomYRotation, 0f);
                    
                    GameObject tile = Instantiate(selectedPrefab, worldPosition, rotation, transform);
                    GridTile gridTile = tile.GetComponent<GridTile>();
                    
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

        private void ReplacePathTiles(GameObject[,] gameObjectGrid)
        {
            Dictionary<GameObject, GameObject> replacements = new();
            
            //Create a replacement for every unique path tile
            foreach (List<GameObject> route in GeneratedPaths)
            {
                foreach (GameObject tile in route)
                {
                    //Multiple paths can share the same tile
                    if (replacements.ContainsKey(tile))
                        continue;
                    
                    GridTile gridTile = tile.GetComponent<GridTile>();
                    Vector2Int coordinates = gridTile.Coordinates;
                    
                    GameObject newTile = Instantiate(pathPrefab, tile.transform.position, tile.transform.rotation, transform);
                    GridTile newGridTile = newTile.GetComponent<GridTile>();
                    newGridTile.Initialize(coordinates);
                    newGridTile.SetType(TileType.Path);
                    newTile.name = "PathTile(Clone)";

                    foreach (Transform child in newTile.GetComponentsInChildren<Transform>())
                    {
                        child.gameObject.layer = LayerMask.NameToLayer("Path");
                    }
                    
                    replacements.Add(tile, newTile);

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

        public List<GameObject> GetPathForSpawnPoint(Transform spawnPoint)
        {
            foreach (List<GameObject> path in GeneratedPaths)
                if (path.Count > 0 && path[0].transform == spawnPoint)
                    return path;

            return null;
        }

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