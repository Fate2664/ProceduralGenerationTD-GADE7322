using UnityEngine;

public class GenerateGrid : MonoBehaviour
{
    [Header("Terrain")]
    [SerializeField] private Terrain targetTerrain;

    [Header("Perlin Noise")] 
    [SerializeField, Min(0.01f)] private float noiseScale = 20f;
    [SerializeField, Min(0f)] private float maxHeight = 20f;

    void Start()
    {
        GenerateTerrain();
    }
    
    [ContextMenu("GenerateTerrain")]
    public void GenerateTerrain()
    {
        TerrainData terrainData = targetTerrain.terrainData;
        int resolution = terrainData.heightmapResolution;
        
        float[,] heights = new float[resolution, resolution];
        float normalizedMaxHeight = maxHeight / terrainData.size.y;

        for (int z = 0; z < resolution; z++)
        {
            for (int x = 0; x < resolution; x++)
            {
                float xNoise = x / noiseScale;
                float zNoise = z / noiseScale;
                float noiseValue = Mathf.PerlinNoise(xNoise, zNoise);
                heights[z, x] = Mathf.Clamp01(noiseValue * normalizedMaxHeight);
            }
        }
        terrainData.SetHeights(0, 0, heights);
    }
}