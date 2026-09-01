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

    public class GridTile : MonoBehaviour
    {
        public Vector2Int Coordinates { get; private set; }
        public TileType Type { get; private set; }
        public GameObject Occupant { get; private set; }

        public bool CanBuild => Type == TileType.Buildable && Occupant == null;
        public event Action<GridTile> OnTileTypeChanged;

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
            OnTileTypeChanged?.Invoke(this);
        }

        public void SetOccupant(GameObject occupant)
        {
            Occupant = occupant;
            OnTileTypeChanged?.Invoke(this);
        }
    }
}