public class LeafTile extends Tile
{
	PImage particleImage = ResourceManager.getImage("LeafParticle");

	float leafChance = 0.001;
	float rumbleLeafChance = 0.005;
	float slowdownCoeff = 0.95;

	public LeafTile(int x, int y)
	{
		super(x, y);

		decalType = "DecalLeaf";

		density = true; //we are dense so we can distinguish ourselves from other blocks and draw the decals
		drawLayer = ABOVE_TILE_LAYER; //so we stick out over wood

		image = ResourceManager.getImage("Leaf");
	}

	void update()
	{
		if(gamePaused)
		{
			return;
		}

		if(random(1) < leafChance * TimeManager.deltaFix)
		{
			spawnLeaf();
		}
	}

	boolean canCollideWith(BaseObject object)
	{
		if(object.canPlayerInteract())
		{
			Player player = (Player) object;
			player.velocity.mult(slowdownCoeff);

			if(random(1) < rumbleLeafChance)
			{
				spawnLeaf();
			}
		}

		return false;
	}

	void spawnLeaf()
	{
		load(new SingleParticle(null, position, new PVector(random(-2, 0), 1), particleImage));
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
