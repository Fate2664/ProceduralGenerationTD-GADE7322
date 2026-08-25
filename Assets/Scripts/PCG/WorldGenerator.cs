using System.Collections.Generic;
using UnityEngine;

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
    
    public List<List<GameObject>> GeneratedPaths { get; private set; }

    void Start()
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
            tile.SetActive(false);
        }
    }

    public GameObject[,] GenerateGrid()
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
}