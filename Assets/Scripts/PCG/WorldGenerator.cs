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

        [Header("Path Settings")] 
        [SerializeField] private int pathCount = 4;
        [SerializeField] private float turnChance = 0.35f;

        [Header("Spawning")] 
        [SerializeField] private GameObject tilePrefab;
        [SerializeField] private GameObject towerPrefab;
        [SerializeField] private Material grassMaterial;
        [SerializeField] private Material dirtMaterial;
        [SerializeField] private NavMeshSurface navMeshSurface;
            
        public float GridOffset => gridOffset;
        public float GridSize => gridSize;
        
        public GridTile[,] Grid { get; private set; }
        public List<List<GameObject>> GeneratedPaths { get; private set; }
        public Transform Tower { get; private set; }
        public Transform[] SpawnPoints { get; private set; }
        public bool IsGenerated { get; private set; }
        
        public event Action Generated;
        
        void Awake()
        {
            GameObject[,] gameObjectGrid = GenerateGrid();
            Path pathGenerator = new Path(gameObjectGrid, turnChance);
            GeneratedPaths = pathGenerator.GeneratePaths(pathCount);

            HashSet<GameObject> allPathTimes = new();
        
            foreach(var route in GeneratedPaths)
            {            
                foreach(var tile in route)
                    allPathTimes.Add(tile);
            }

            foreach (GameObject tile in allPathTimes)
            {
                GridTile gridTile = tile.GetComponent<GridTile>();
                gridTile.SetType(TileType.Path);
                
                tile.gameObject.GetComponentInChildren<Renderer>().material = dirtMaterial;
                //Switch to path layer
                foreach (Transform child in tile.GetComponentsInChildren<Transform>())
                    child.gameObject.layer = LayerMask.NameToLayer("Path");
                //Change name
                tile.gameObject.name = "PathTile(Clone)";
            }
            
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
            
            float halfGridSize = (gridSize - 1) * gridOffset * 0.5f;
        
            for (int x = 0; x < gridSize; x++)
            {
                for (int z = 0; z < gridSize; z++)
                {
                    Vector3 localOffset = new Vector3(x * gridOffset - halfGridSize, 0f, z * gridOffset - halfGridSize);
                    Vector3 worldPosition = transform.position + localOffset;
                    GameObject tile = Instantiate(tilePrefab, worldPosition, Quaternion.identity, transform);
                    GridTile gridTile = tile.GetComponent<GridTile>();
                    
                    gridTile.Initialize(new Vector2Int(x, z));
                    gameObjectGrid[x, z] = tile;
                    Grid[x, z] = gridTile;
                }
            }
            return gameObjectGrid;
        }

        public List<GameObject> GetPathForSpawnPoint(Transform spawnPoint)
        {
            foreach (List<GameObject> path in GeneratedPaths)
                if (path.Count > 0 && path[0].transform == spawnPoint)
                    return path;

            return null;
        }
    }
}