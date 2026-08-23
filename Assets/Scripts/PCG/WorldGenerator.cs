using System.Collections.Generic;
using UnityEngine;

public class WorldGenerator : MonoBehaviour
{
    [Header("Grid Settings")] 
    [SerializeField] private int gridSize = 10;
    [SerializeField] private float gridOffset = 2;

    [Header("Spawning")] 
    [SerializeField] private GameObject tilePrefab;
    
    public static List<GameObject> generatedTiles = new List<GameObject>();

    void Start()
    {
        Path pathGenerator = new Path(gridSize);
        GenerateGrid(pathGenerator);
        pathGenerator.GeneratePath();
        
        foreach(var pObject in pathGenerator.GetPath())
        {            
            pObject.SetActive(false);
        }
    }

    public void GenerateGrid(Path pathGenerator)
    {
        for (int x = 0; x < gridSize; x++)
        {
            for (int z = 0; z < gridSize; z++)
            {
                Vector3 pos = new Vector3(x * gridOffset, 0, z * gridOffset);
                GameObject tile = Instantiate(tilePrefab, pos, Quaternion.identity) as GameObject;
                
                generatedTiles.Add(tile);
                pathGenerator.AssignTopAndBottomTiles(z, tile);
                tile.transform.SetParent(transform);
            }
        }
    }
}