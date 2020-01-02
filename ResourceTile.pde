public class ResourceTile extends Tile
{
	int value;
	int pickupDropAmountValue = 1;
	PImage pickupImage;
	boolean hasDroppedResources;

	public ResourceTile(int x, int y)
	{
		super(x, y);
	}

	//When the player mines the tile drops ore
	void mine(boolean playBreakSound)
	{
		super.mine(playBreakSound);

		// Check if the tile already dropped an ore
		if (hasDroppedResources)
		{
			return;
		}

		hasDroppedResources = true;

		//Drop the ores give them the position
		for (int i = 0; i < pickupDropAmountValue; i++)
		{
			load(new ScorePickup(this), new PVector(position.x + 10 + random(size.x - 60), position.y + 10 + random(size.y - 60)));
		}
	}

	//If a meteor destroys the tile it wont drop any ores
	void mine(boolean playBreakSound, boolean doResourceDrop)
	{
		super.mine(playBreakSound);

		// Check if the tile already dropped an ore
		if (hasDroppedResources)
		{
			return;
		}

		hasDroppedResources = true;

		if (!doResourceDrop)
		{
			return;
		}

		//Drop the ores give them the position
		for (int i = 0; i < pickupDropAmountValue; i++)
		{
			load(new ScorePickup(this), new PVector(position.x + 10 + random(size.x - 60), position.y + 10 + random(size.y - 60)));
		}
	}
}
