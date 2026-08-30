using System.Collections.Generic;
using System.Linq;
using Unity.AI.Navigation;
using UnityEngine;

namespace PCG
{
    public class WorldGenerator : MonoBehaviour
    {
        [Header("Grid Settings")] 
        [SerializeField] private int gridSize = 11; //Must be odd number for there to be one center tile
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
            
        public List<List<GameObject>> GeneratedPaths { get; private set; }
        public Transform Tower { get; private set; }
        public Transform[] SpawnPoints { get; private set; }
        public bool IsGenerated { get; private set; }
        
        void Awake()
        {
            GameObject[,] grid = GenerateGrid();
        
            Path pathGenerator = new Path(grid, turnChance);
            GeneratedPaths = pathGenerator.GeneratePaths(pathCount);

            HashSet<GameObject> allPathTimes = new();
        
            foreach(var route in GeneratedPaths)
            {            
                foreach(var tile in route)
                    allPathTimes.Add(tile);
            }

            foreach (GameObject tile in allPathTimes)
            {
                tile.gameObject.GetComponentInChildren<Renderer>().material = dirtMaterial;
                //Switch to path layer
                foreach (Transform child in tile.GetComponentsInChildren<Transform>())
                    child.gameObject.layer = LayerMask.NameToLayer("Path");
                //Change name
                tile.gameObject.name = "PathTile(Clone)";
            }
            
            SpawnPoints = GeneratedPaths.Select(path => path[0].transform).ToArray();
            Tower = PlaceTowerAtCenter(grid);
            
            navMeshSurface.BuildNavMesh();
            IsGenerated = true;
        }

        private Transform PlaceTowerAtCenter(GameObject[,] grid)
        {
            int centerX = grid.GetLength(0) / 2;
            int centerZ = grid.GetLength(1) / 2;
            Vector3 centerPos = grid[centerX, centerZ].transform.position;
            return Instantiate(towerPrefab, centerPos, Quaternion.identity, transform).transform;  
        }

        private GameObject[,] GenerateGrid()
        {
            GameObject[,] grid = new GameObject[gridSize, gridSize];
        
            for (int x = 0; x < gridSize; x++)
            {
                for (int z = 0; z < gridSize; z++)
                {
                    Vector3 pos = new Vector3(x * gridOffset, 0f, z * gridOffset);
                    GameObject tile = Instantiate(tilePrefab, pos, Quaternion.identity, transform);
                
                    grid[x, z] = tile;
                }
            }
            return grid;
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