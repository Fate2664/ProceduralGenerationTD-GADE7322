using System;
using UnityEngine;

namespace PCG
{
    public enum TileType
    {
        Buildable,
        Path,
        Obstacle
    }
    
    //The GridTile datatype represents a single tile in the generated grid
    public class GridTile : MonoBehaviour
    {
        public Vector2Int Coordinates { get; private set; } //Tile's coordinates
        public TileType Type { get; private set; }  //Tile's type
        public GameObject Occupant { get; private set; }    //Whether or not the tile is occupied

        public bool CanBuild => Type == TileType.Buildable && Occupant == null; //Determines if the you can build on this tile
        public event Action<GridTile> OnTileStateChanged;
    
        //This method sets the tile's grid position and gives it a defualt state
        public void Initialize(Vector2Int coordinates)
        {
            Coordinates = coordinates;
            Type = TileType.Buildable;
            Occupant = null;
        }

        public void SetType(TileType type)
        {
            if (Type == type)
                return;

            Type = type;
            OnTileStateChanged?.Invoke(this);
        }

        public void SetOccupant(GameObject occupant)
        {
            Occupant = occupant;
            OnTileStateChanged?.Invoke(this);
        }
    }
}