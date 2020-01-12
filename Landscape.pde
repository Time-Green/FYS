public class LeafTile extends SlowFallTile
{
	public LeafTile(int x, int y)
	{
		super(x, y);

		decalType = "DecalLeaf";

		density = true; //we are dense so we can distinguish ourselves from other blocks and draw the decals
		drawLayer = ABOVE_TILE_LAYER; //so we stick out over wood

		image = ResourceManager.getImage("Leaf");
		particleImage = ResourceManager.getImage("LeafParticle");
	}
}

public class WoodTile extends Tile
{
	public WoodTile(int x, int y)
	{
		super(x, y);
		drawLayer = BACKWALL_LAYER;

		image = ResourceManager.getImage("Wood");
		density = false; 
		destroyedImage = null;
	}
}

public class WoodBirchTile extends Tile
{
	public WoodBirchTile(int x, int y)
	{
		super(x, y);
		drawLayer = BACKWALL_LAYER;

		image = ResourceManager.getImage("WoodBirch");
		density = false; 
		destroyedImage = null;
	}
}
