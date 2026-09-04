using System.Collections.Generic;
using System.Linq;
using PCG;
using UnityEngine;

public class Path
{
    private GameObject[,] tiles;
    private int sizeX;
    private int sizeZ;
    //Probability that the path is allowed to change direction
    private float turnChance;
    
    //The four directions in which a path can move
    private static readonly Vector2Int[] directions =
    {
        Vector2Int.up,
        Vector2Int.down,
        Vector2Int.right,
        Vector2Int.left
    };
    
    public Path(GameObject[,] tiles, float turnChance = 0.35f)
    {
        this.tiles = tiles;
        this.turnChance = turnChance;
        
        sizeX = tiles.GetLength(0);
        sizeZ = tiles.GetLength(1);
    }

    //This method generates multiple paths from the edge of the grid to the grid center
    public List<List<GameObject>> GeneratePaths(int requestedPathCount)
    {
        //Calculate center tile
        Vector2Int centerTile = new Vector2Int(sizeX / 2, sizeZ / 2);
        //Find every walkable tile connected to the center
        HashSet<Vector2Int> reachableTiles = GetReachableTiles(centerTile);
        
        //Get grid perimeter and keep only the ones that can reach the center
        List<Vector2Int> perimeter = GetPerimeterCoords().Where(coord => reachableTiles.Contains(coord)).ToList();
        
        List<List<GameObject>> paths = new ();
        
        //Make sure path count is between 1 and max of perimeter
        int pathCount = Mathf.Clamp(requestedPathCount, 1, perimeter.Count);
        
        //Get starting tiles
        List<Vector2Int> startingTiles = GetStartingTiles(perimeter, pathCount);
        
        foreach (Vector2Int start in startingTiles)
        {
            //Generate an individual route from this perimeter tile to the center
            List<GameObject> path = GenerateSinglePath(start, centerTile);
            if (path != null)
                //add it to the paths list
                paths.Add(path);
        }
        
        return paths;
    }

    //This method uses the breadth first search algorithm to find a walkable route between two tiles
    private List<GameObject> GenerateSinglePath(Vector2Int start, Vector2Int end)
    {
        if (!IsWalkable(start) || !IsWalkable(end))
            return null;
        
        Queue<Vector2Int> frontier = new(); //The tiles waiting to be explored by the breadth first search
        Dictionary<Vector2Int, Vector2Int> cameFrom = new(); //We record which tile led to each visited tile
        
        frontier.Enqueue(start);
        cameFrom[start] = start;

        while (frontier.Count > 0)
        {
            Vector2Int current = frontier.Dequeue();
            
            //Stop searching when destination has been reached
            if (current == end)
                break;

            Vector2Int previousDirection = Vector2Int.zero;
            
            if (current != start)
                previousDirection = current - cameFrom[current];

            List<Vector2Int> neighbours = GetWalkableNeighbours(current, previousDirection);

            foreach (Vector2Int neighbour in neighbours)
            {
                //Skip tiles that have already been visited
                if (cameFrom.ContainsKey(neighbour))
                    continue;

                cameFrom[neighbour] = current;
                frontier.Enqueue(neighbour);
            }
        }

        //No route was found
        if (!cameFrom.ContainsKey(end))
            return null;
        
        //Construct a path by following the recorded tiles backwards from the center to the starting tile
        List<GameObject> path = new ();
        Vector2Int pathCoordinate = end;

        while (pathCoordinate != start)
        {
            path.Add(tiles[pathCoordinate.x, pathCoordinate.y]);
            pathCoordinate = cameFrom[pathCoordinate];
        }
        
        path.Add(tiles[start.x, start.y]);
        path.Reverse();
        
        return path;
    }
    
    //This method selects starting tiles on the perimeter that are approximately evenly separated
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

    //This method returns the coordinates of the perimeter tiles
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
    
    //This checks whether a tile coordinate lies within grid boundaries
    private bool IsInsideGrid(Vector2Int coordinate)
    {
        return coordinate.x >= 0 &&
               coordinate.x < sizeX &&
               coordinate.y >= 0 &&
               coordinate.y < sizeZ;
    }
    
    //This checks whether a coordinate is inside the grid and is not an obstacle
    private bool IsWalkable(Vector2Int coordinate)
    {
        if (!IsInsideGrid(coordinate))
            return false;

        GridTile gridTile = tiles[coordinate.x, coordinate.y].GetComponent<GridTile>();

        return gridTile.Type != TileType.Obstacle;
    }

    //The method finds walkable adjacent tiles and determines the order in which the pathfinding will explore them
    private List<Vector2Int> GetWalkableNeighbours(Vector2Int coordinate, Vector2Int previousDirection)
    {
        List<Vector2Int> neighbours = new();
    
        //Collect every walkable neighbour in the four directions
        foreach (var direction in directions)
        {
            Vector2Int neighbour = coordinate + direction;
            
            if (IsWalkable(neighbour))
                neighbours.Add(neighbour);
        }
        
        //Randomly shuffle the options in the array
        for (int i = neighbours.Count - 1; i > 0; i--)
        {
            int randomIndex = UnityEngine.Random.Range(0, i + 1);
            
            Vector2Int temp = neighbours[i];
            neighbours[i] = neighbours[randomIndex];
            neighbours[randomIndex] = temp;
        }
        
        //Prioitise continueing in the previous direction
        if (UnityEngine.Random.value > turnChance)
        {
            Vector2Int straightCoordinate = coordinate + previousDirection;
            int straightIndex = neighbours.IndexOf(straightCoordinate);

            if (straightIndex > 0)
            {
                Vector2Int temp = neighbours[0];
                neighbours[0] = neighbours[straightIndex];
                neighbours[straightIndex] = temp;
            }
        } 
        return neighbours;
    }

    //This method finds all walkable tiles connected to the starting coordinate
    private HashSet<Vector2Int> GetReachableTiles(Vector2Int start)
    {
        HashSet<Vector2Int> reachable = new();
        Queue<Vector2Int> frontier = new();
        
        if (!IsWalkable(start))
            return reachable;
        
        reachable.Add(start);
        frontier.Enqueue(start);

        while (frontier.Count > 0)
        {
            Vector2Int current = frontier.Dequeue();

            foreach (Vector2Int direction in directions)
            {
                Vector2Int neighbour = current + direction;
                
                if (!IsWalkable(neighbour) || !reachable.Add(neighbour))
                    continue;
                
                frontier.Enqueue(neighbour);
            }
        }
        
        return reachable;
    }

}