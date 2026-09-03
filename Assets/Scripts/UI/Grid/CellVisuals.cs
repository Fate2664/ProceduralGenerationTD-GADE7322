using Nova;
using PCG;
using UnityEngine;

[System.Serializable]
public class CellVisuals : ItemVisuals
{
    public UIBlock2D Background;
    public Color DefaultColor = Color.white;
    public Color HoveredColor = Color.white;
    public Color PressedColor = Color.grey;
    public Color ObstacleColor =new(0.95f, 0.35f, 0.35f, 1f);
    public Color OccupientColor = new(0.95f, 0.35f, 0.35f, 1f);

    private GridTile DataSource;
    public GridTile BoundTile => DataSource;

    public void Initialize(GridTile dataSource)
    {
        if (DataSource != null)
            DataSource.OnTileTypeChanged -= HandleTileChanged;
        
        DataSource = dataSource;

        if (DataSource != null)
            DataSource.OnTileTypeChanged += HandleTileChanged;

        RefreshVisuals();
    }

    public void UnBind(GridTile dataSource)
    {
        if (DataSource != dataSource)
            return;

        DataSource.OnTileTypeChanged -= HandleTileChanged;
        DataSource = null;
    }

    public void HandleTileChanged(GridTile tile)
    {
        if (tile == DataSource)
            RefreshVisuals();
    }

    public void RefreshVisuals()
    {
        bool shouldBeVisible = DataSource.Type != TileType.Path;
        Background.BodyEnabled = shouldBeVisible;

        if (!shouldBeVisible)
            return;

        Background.Color = DataSource.Type == TileType.Obstacle ? ObstacleColor : DataSource.Occupant != null ? OccupientColor : DefaultColor;
    }

    #region Gesture Visuals

    public static void HandleHover(Gesture.OnHover evt, CellVisuals target)
    {
        if (target.DataSource?.CanBuild != true)
            return;

        target.Background.Color = target.HoveredColor;
    }

    public static void HandleUnhover(Gesture.OnUnhover evt, CellVisuals target)
    {
        target.RefreshVisuals();
    }

    public static void HandlePress(Gesture.OnPress evt, CellVisuals target)
    {
        if (target.DataSource?.CanBuild != true)
            return;

        target.Background.Color = target.PressedColor;
    }

    #endregion
}