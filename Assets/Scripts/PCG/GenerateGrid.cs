using UnityEngine;

public class GenerateGrid : MonoBehaviour
{
    [Header("Grid Settings")] 
    [SerializeField] private int gridSizeX = 30;
    [SerializeField] private int gridSizeZ = 30;
    [SerializeField] private int gridOffset = 2;

    [Header("Spawning")] 
    [SerializeField] private GameObject blockPrefab;

    void Start()
    {
        GridGeneration();
    }

    public void GridGeneration()
    {
        for (int x = 0; x < gridSizeX; x++)
        {
            for (int z = 0; z < gridSizeZ; z++)
            {
                Vector3 pos = new Vector3(x * gridOffset, 0, z * gridOffset);
                GameObject block = Instantiate(blockPrefab, pos, Quaternion.identity) as GameObject;
                block.transform.SetParent(transform);
            }
        }
    }
}