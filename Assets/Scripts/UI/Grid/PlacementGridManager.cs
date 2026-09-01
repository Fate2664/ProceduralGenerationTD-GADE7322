using System;
using System.Collections.Generic;
using Nova;
using PCG;
using UnityEngine;

public class PlacementGridManager : MonoBehaviour
{
    [Header("References")] public UIBlock Root;
    public GridView CellGrid;
    public WorldGenerator WorldGenerator;

    [Header("Layout")] 
    [SerializeField] private float cellSize = 1.5f;
    [SerializeField] private float surfaceOffset = 0.18f; //Height above the tile gameobject

    private readonly List<GridTile> cells = new();
    private float cellSpacing;
    private bool handlersRegistered;

    public event Action<GridTile> CellHovered;
    public event Action<GridTile> CellUnhovered;
    public event Action<GridTile> CellClicked;

    private void Start()
    {
        RegisterHandlers();

        if (WorldGenerator.IsGenerated)
        {
            InitializeGrid();
        }
        else
        {
            WorldGenerator.Generated += InitializeGrid;
        }
    }

    private void RegisterHandlers()
    {
        if (handlersRegistered)
            return;

        //Visuals
        Root.AddGestureHandler<Gesture.OnHover, CellVisuals>(CellVisuals.HandleHover);
        Root.AddGestureHandler<Gesture.OnUnhover, CellVisuals>(CellVisuals.HandleUnhover);
        Root.AddGestureHandler<Gesture.OnPress, CellVisuals>(CellVisuals.HandlePress);

        //State-Changing
        CellGrid.AddGestureHandler<Gesture.OnClick, CellVisuals>(HandleCellClicked);

        //Data Binding
        CellGrid.AddDataBinder<GridTile, CellVisuals>(BindCell);
        CellGrid.AddDataUnbinder<GridTile, CellVisuals>(UnbindCell);

        //Contols spacing between cells across each row
        CellGrid.SetSliceProvider(ProvideGridSlice);

        handlersRegistered = true;
    }

    private void InitializeGrid()
    {
        WorldGenerator.Generated -= InitializeGrid;

        GridTile[,] generatedGrid = WorldGenerator.Grid;
        bool wasInactive = !Root.gameObject.activeSelf;

        if (wasInactive)
            Root.gameObject.SetActive(true);

        CellGrid.SetDataSource<GridTile>(null);
        cells.Clear();

        int colums = generatedGrid.GetLength(0);
        int rows = generatedGrid.GetLength(1);

        for (int z = 0; z < rows; z++)
        {
            for (int x = 0; x < colums; x++)
            {
                cells.Add(generatedGrid[x, z]);
            }
        }

        //Configure grid depending on world grid size
        cellSpacing = WorldGenerator.GridOffset - cellSize;
        CellGrid.CrossAxisItemCount = colums;

        CellGrid.UIBlock.AutoLayout.Spacing = Length.FixedValue(cellSpacing);

        float width = colums * cellSize + (colums - 1) * cellSpacing;
        float height = rows * cellSize + (rows - 1) * cellSpacing;

        CellGrid.UIBlock.Size.X = Length.FixedValue(width);
        CellGrid.UIBlock.Size.Y = Length.FixedValue(height);

        Vector3 firstPosition = generatedGrid[0, 0].transform.position;
        Vector3 lastPosition = generatedGrid[colums - 1, rows - 1].transform.position;
        Vector3 center = (firstPosition + lastPosition) / 2f;

        center.y = firstPosition.y + surfaceOffset;

        Root.TrySetWorldPosition(center);

        CellGrid.SetDataSource(cells);

        if (wasInactive)
            Root.gameObject.SetActive(false);
    }

    private void ProvideGridSlice(int sliceIndex, GridView gridView, ref GridSlice slice)
    {
        slice.AutoLayout.Alignment = 0;
        slice.AutoLayout.AutoSpace = false;
        slice.AutoLayout.Spacing = Length.FixedValue(cellSpacing);
    }

    //Data Binding
    private void BindCell(Data.OnBind<GridTile> evt, CellVisuals target, int index)
    {
        target.Initialize(evt.UserData);
    }

    //Gesture Handling
    private void HandleCellClicked(Gesture.OnClick evt, CellVisuals target, int index)
    {
        GridTile tile = cells[index];
        if (tile != null) 
            CellClicked?.Invoke(tile);
    }

    public void ShowGrid()
    {
        Root.gameObject.SetActive(true);
        CellGrid.Refresh();
    }

    public void HideGrid()
    {
        Root.gameObject.SetActive(false);
    }

    private void OnDestroy()
    {
        if (WorldGenerator != null)
        {
            WorldGenerator.Generated -= InitializeGrid;
        }
    }

    private void UnbindCell(Data.OnUnbind<GridTile> evt, CellVisuals target, int index)
    {
        target.UnBind(evt.UserData);
    }
}