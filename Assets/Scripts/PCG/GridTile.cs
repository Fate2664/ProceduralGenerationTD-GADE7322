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
        [SerializeField] private Renderer groundRenderer;

        public TerrainType Terrain { get; private set; }
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
            Terrain = TerrainType.Grassland;
            Occupant = null;
        }

        public void SetTerrain(TerrainType terrain)
        {
            if (Terrain == terrain)
                return;

            Terrain = terrain;
            OnTileStateChanged?.Invoke(this);
        }

        public void ApplyTerrainColor(Color color)
        {
            var properties = new MaterialPropertyBlock();
            groundRenderer.GetPropertyBlock(properties);
            properties.SetColor("_BaseColor", color);
            properties.SetColor("_Color", color);
            groundRenderer.SetPropertyBlock(properties);
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
