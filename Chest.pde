class Chest extends Obstacle
{
	private final int MIN_RANDOM_LOOT_AMOUNT = 2;

	private boolean opened = false;
	private int forcedKey = -1; //set to something zero or above if you want a specific set of contents

	private float jumpiness = -35; //how far our contents jump out
	private float sideWobble = 5; //vertical velocity of item ranging between -sideWobble and sideWobble

	private PImage openState = ResourceManager.getImage("ChestOpen");

	private ArrayList<Movable> contents = new ArrayList<Movable>();

	public Chest()
	{
		setup();
	}

	public Chest(int forcedKey)
	{
		if(forcedKey > 0)
		{
			this.forcedKey = forcedKey;
		}

		setup();
	}

	private void setup()
	{
		populateContents();
		anchored = false;

		image = ResourceManager.getImage("Chest");
	}

	// only load childtypes of Movable
	private void populateContents()
	{
		ArrayList<Movable> newContents = new ArrayList<Movable>();

		int randomKey = floor(random(2));

		if (forcedKey >= 0)
		{
			randomKey = forcedKey;
		}

		if(randomKey == 0)
		{
			RelicShard relicShard = new RelicShard();
			load(relicShard, position);

			newContents.add(relicShard);
			addRandomLoot(newContents);
		}
		else if(randomKey == 1)
		{
			addRandomLoot(newContents);
		}

		// I dont want to force every new content thingy to Movable seperately, so do it here
		for (Movable newContent : newContents)
		{
			contents.add(newContent);
		}

		for (Movable movable : contents)
		{
			movable.suspended = true;
		}
	}

	private void addRandomLoot(ArrayList<Movable> newContents)
	{
		int lootAmount;

		// in rare occasions (mostly when respawning) the player could be null
		if(player != null)
		{
			lootAmount = MIN_RANDOM_LOOT_AMOUNT + floor(player.getDepth() / 250) + floor(random(2));
		}
		else
		{
			lootAmount = MIN_RANDOM_LOOT_AMOUNT + floor(random(4));
		}

		for(int i = 0; i < lootAmount; i++)
		{
			int lootType = floor(random(3));
			ScorePickup scorePickup = null;

			if(lootType == 0)
			{
				scorePickup = new ScorePickup(IRON_VALUE, ResourceManager.getImage("IronPickup"));
			}
			else if(lootType == 1)
			{
				scorePickup = new ScorePickup(GOLD_VALUE, ResourceManager.getImage("GoldPickup"));
			}
			else if(lootType == 2)
			{
				scorePickup = new ScorePickup(DIAMOND_VALUE, ResourceManager.getImage("DiamondPickup"));
			}

			load(scorePickup, position);
			newContents.add(scorePickup);
		}
	}

	public void pushed(Movable movable, float x, float y)
	{
		super.pushed(movable, x, y);

		if(!opened && movable.canPlayerInteract())
		{
			openChest();
		}
	}

	public void takeDamage(float damageTaken)
	{
		super.takeDamage(damageTaken);

		for (Movable movable : contents)
		{
			delete(movable);
		}

		contents.clear();

		delete(this);
	}

	private void openChest()
	{
		AudioManager.playSoundEffect("ChestOpen");

		for (Movable movable : contents)
		{
			movable.position.set(new PVector(position.x, position.y - TILE_SIZE));
			movable.suspended = false;

			movable.velocity.y = random(jumpiness / 4, jumpiness);
			movable.velocity.x = random(-sideWobble, sideWobble);
		}

		contents.clear();
		opened = true;
		image = openState;
	}
}
