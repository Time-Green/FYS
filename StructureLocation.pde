public class StructureLocation
{
    private PVector spawnAtGrid = new PVector();
    private PVector sizeInGrid = new PVector();

    public StructureLocation (PVector spawnAtGrid, PVector size)
    {
        this.spawnAtGrid.set(spawnAtGrid);
        sizeInGrid.set(size);
    }

    public boolean isInsideStructure (PVector position, PVector size)
    {
        return CollisionHelper.rectRect(position, size, spawnAtGrid, sizeInGrid);
    }

    public int getTopYPosition ()
    {
        return floor((spawnAtGrid.y + sizeInGrid.y) * TILE_SIZE);
    }
}
