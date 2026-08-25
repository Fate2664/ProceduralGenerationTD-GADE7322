using System.Collections.Generic;
using UnityEngine;

public class Path
{
    private GameObject[,] tiles;
    private int sizeX;
    private int sizeZ;
    private float turnChance;
    
    public Path(GameObject[,] tiles, float turnChance = 0.35f)
    {
        this.tiles = tiles;
        this.turnChance = turnChance;
        
        sizeX = tiles.GetLength(0);
        sizeZ = tiles.GetLength(1);
    }

    public List<List<GameObject>> GeneratePaths(int requestedPathCount)
    {
        //Get grid perimeter
        List<Vector2Int> perimeter = GetPerimeterCoords();
        
        //Make sure path count is between 1 and max of perimeter
        int pathCount = Mathf.Clamp(requestedPathCount, 1, perimeter.Count);
        
        //Get starting tiles
        List<Vector2Int> startingTiles = GetStartingTiles(perimeter, pathCount);
        
        //Calculate center tile
        Vector2Int centerTile = new Vector2Int(sizeX / 2, sizeZ / 2);
        
        List<List<GameObject>> paths = new ();

        foreach (Vector2Int start in startingTiles)
        {
            paths.Add(GenerateSinglePath(start, centerTile));
        }
        
        return paths;
    }

    private List<GameObject> GenerateSinglePath(Vector2Int start, Vector2Int end)
    {
        List<GameObject> path = new();
        Vector2Int currentTile = start;
        Vector2Int previousDirection = Vector2Int.zero;
        
        //Add the starting tile to the path list
        path.Add(tiles[currentTile.x, currentTile.y]);

        while (currentTile != end)
        {
            List<Vector2Int> validDirections = new ();
            Vector2Int direction;
            
            //Check for valid directions
            if (currentTile.x < end.x)
                validDirections.Add(Vector2Int.right);
            else if (currentTile.x > end.x)
                validDirections.Add(Vector2Int.left);
            
            if (currentTile.y < end.y)
                validDirections.Add(Vector2Int.up);
            else if (currentTile.y > end.y)
                validDirections.Add(Vector2Int.down);

            //Check if it can continue to go forward
            bool canContinueStraight = validDirections.Contains(previousDirection);

            //If it can continue straight and if the random value is greater than the turning chance
            if (canContinueStraight && Random.value > turnChance)
            {
                direction = previousDirection;
            }
            else
            {
                direction = validDirections[Random.Range(0, validDirections.Count)];
            }

            currentTile += direction;
            previousDirection = direction;
            
            //Add next tile to the list
            path.Add(tiles[currentTile.x, currentTile.y]);
        }
        
        return path;
    }
    
    private List<Vector2Int> GetStartingTiles(List<Vector2Int> perimeter, int count)
    {
        List<Vector2Int> starts = new();
        int offset = Random.Range(0, perimeter.Count);

        for (int i = 0; i < count; i++)
        {
            //This line tries to choose a starting tile on the perimeter that is evenly spaced apart from the others
            //E.g: for 4 starts
            //Path 0 = (3 + 0) % 40 = 3
            //Path 1 = (3 + 10) % 40 = 13
            //Path 2 = (3 + 20) % 40 = 23
            //Path 3 = (3 + 30) % 40 = 33
            int index = (offset + Mathf.FloorToInt(i * perimeter.Count / (float)count)) % perimeter.Count; 
            starts.Add(perimeter[index]);
        }

        return starts;
    }

    private List<Vector2Int> GetPerimeterCoords()
    {
        List<Vector2Int> perimeter = new();
        
        //Top
        for (int x = 0; x < sizeX; x++)
            perimeter.Add(new Vector2Int(x, 0));
        
        //Right
        for (int z = 1; z < sizeZ; z++)
            perimeter.Add(new Vector2Int(sizeX - 1, z));
        
        //Bottom
        for (int x = sizeX - 2; x >= 0; x--)
            perimeter.Add(new Vector2Int(x, sizeZ - 1));
        
        //Left
        for (int z = sizeZ - 2; z > 0; z--)
            perimeter.Add(new Vector2Int(0, z));
        
        return perimeter;
    }

   
}