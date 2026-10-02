using System.Collections.Generic;
using System.Linq;
using PCG;
using UnityEngine;

namespace PCG
{
    //Path class is now a data class
    public class Path
    {
        public int Id { get; }
        private readonly List<GridTile> tiles;
        public IReadOnlyList<GridTile> Tiles { get; }
        public Transform SpawnPoint => Tiles[0].transform;
        public Transform EndPoint => Tiles[Tiles.Count - 1].transform;
        public int TileCount => Tiles.Count;
        public float Length { get; }

        public Path(int id, IEnumerable<GridTile> tiles)
        {
            this.tiles = new List<GridTile>(tiles);
            Id = id;
            Tiles = this.tiles.AsReadOnly();
            float length = 0f;
            
            for (int i = 0; i < this.tiles.Count; i++)
            {
                if (i > 0)
                {
                    length += Vector3.Distance(this.tiles[i - 1].transform.position, this.tiles[i].transform.position);
                }
            }

            Length = length;
        }
        
        public void ReplaceTile(int index, GridTile replacement)
        {
            tiles[index] = replacement;
        }
    }
}