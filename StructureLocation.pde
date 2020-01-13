public class StructureLocation
{
    private PVector spawnAtGrid = new PVector();
    private PVector sizeInGrid = new PVector();

    public StructureLocation (PVector spawnAtGrid, PVector size)
    {
        this.spawnAtGrid.set(spawnAtGrid);
        sizeInGrid.set(size);
    }

    public boolean isInsideStructure (PVector gridPosition)
    {
        return CollisionHelper.pointRect(gridPosition, spawnAtGrid, sizeInGrid);
    }

    public int getMaxYPosition ()
    {
        return floor((spawnAtGrid.y + sizeInGrid.y) * TILE_SIZE);
    }
}
