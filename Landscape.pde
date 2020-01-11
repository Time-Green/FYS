public class LeafTile extends Tile
{
	PImage particleImage = ResourceManager.getImage("LeafParticle");

	float leafChance = 0.001;

	public LeafTile(int x, int y)
	{
		super(x, y);
		drawLayer = BACKWALL_LAYER;

		image = ResourceManager.getImage("Leaf");
	}

	void update()
	{
		if(gamePaused)
		{
			return;
		}

		if(random(1) < leafChance)
		{
			load(new SingleParticle(null, position, new PVector(random(-2, 0), 1), particleImage));
		}
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
