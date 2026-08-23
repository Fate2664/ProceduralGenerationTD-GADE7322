using System.Collections.Generic;
using UnityEngine;

public class Path
{
    private List<GameObject> path = new();
    private List<GameObject> topTiles = new();
    private List<GameObject> bottomTiles = new();

    private int gridSize;
    private int currentTileIndex;

    private bool hasReachedX;
    private bool hasReachedZ;
    
    private GameObject startingTile;
    private GameObject endingTile;
    
    public List<GameObject> GetPath() => path;

    public Path(int gridSize)
    {
        this.gridSize = gridSize;
    }

    public void AssignTopAndBottomTiles(int z, GameObject tile)
    {
        if (z == 0)
            topTiles.Add(tile);
        if (z == gridSize - 1)
            bottomTiles.Add(tile);
    }

    private bool AssignCheckStartingEndingTiles()
    {
        int xIndex = Random.Range(0, topTiles.Count - 1);
        int zIndex = Random.Range(0, bottomTiles.Count - 1);
        
        startingTile = topTiles[xIndex];
        endingTile = bottomTiles[zIndex];
        
        return startingTile != null && endingTile != null;
    }

    public void GeneratePath()
    {
        if (AssignCheckStartingEndingTiles())
        {
            GameObject currentTile = startingTile;

            var safteyBreakX = 0;
            while (!hasReachedX)
            {
                safteyBreakX++;
                if (safteyBreakX >= 100)
                    break;

                if (currentTile.transform.position.x > endingTile.transform.position.x)
                    MoveDown(ref currentTile);
                else if (currentTile.transform.position.x < endingTile.transform.position.x)
                    MoveUp(ref currentTile);
                else 
                    hasReachedX = true;
            }

            var safteyBreakZ = 0;
            while (!hasReachedZ)
            {
                safteyBreakZ++;
                if (safteyBreakZ >= 100)
                    break;

                if (currentTile.transform.position.z > endingTile.transform.position.z)
                    MoveRight(ref currentTile);
                else if (currentTile.transform.position.z < endingTile.transform.position.z)
                    MoveLeft(ref currentTile);
                else 
                    hasReachedZ = true;
            }
            
            path.Add(endingTile);
        }
    }

    private void MoveDown(ref GameObject currentTile)
    {
        path.Add(currentTile);
        currentTileIndex = WorldGenerator.generatedTiles.IndexOf(currentTile);
        int n = currentTileIndex - gridSize;
        currentTile = WorldGenerator.generatedTiles[n];
    }
    
    private void MoveUp(ref GameObject currentTile)
    {
        path.Add(currentTile);
        currentTileIndex = WorldGenerator.generatedTiles.IndexOf(currentTile);
        int n = currentTileIndex + gridSize;
        currentTile = WorldGenerator.generatedTiles[n];
    }

    private void MoveLeft(ref GameObject currentTile)
    {
        path.Add(currentTile);
        currentTileIndex = WorldGenerator.generatedTiles.IndexOf(currentTile);
        currentTileIndex++;
        currentTile = WorldGenerator.generatedTiles[currentTileIndex];
    }
    
    private void MoveRight(ref GameObject currentTile)
    {
        path.Add(currentTile);
        currentTileIndex = WorldGenerator.generatedTiles.IndexOf(currentTile);
        currentTileIndex--;
        currentTile = WorldGenerator.generatedTiles[currentTileIndex];
    }
}