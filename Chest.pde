class Chest extends Obstacle
{
	boolean opened = false;
	int forcedKey = -1; //set to something zero or above if you want a specific set of contents

	float jumpiness = -35; //how far our contents jump out
	float sideWobble = 5; //vertical velocity of item ranging between -sideWobble and sideWobble

	PImage openState = ResourceManager.getImage("ChestOpen");

	ArrayList<Movable> contents = new ArrayList<Movable>();

	Chest()
	{
		setup();
	}

	Chest(int forcedKey)
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
	void populateContents()
	{
		ArrayList<Movable> newContents = new ArrayList<Movable>();

		int randomKey = floor(random(2));

		if (forcedKey >= 0)
		{
			randomKey = forcedKey;
		}

		//println("randomKey: " + randomKey);

		switch(randomKey)
		{
			case 0:
				RelicShard relicShard = new RelicShard();
				load(relicShard);

				newContents.add(relicShard);
				addRandomLoot(newContents, 18);
			break;

			case 1:
				for (int i = 0; i < 3; i++)
				{
					Dynamite dynamite = new Dynamite();
					load(dynamite);

					newContents.add(dynamite);
				}

				addRandomLoot(newContents, 18);
			break;
			
			case 70:
				RelicShard testRelicShard = new RelicShard();
				load(testRelicShard);

				newContents.add(testRelicShard);
				addRandomLoot(newContents, 6);
			break;
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

	void addRandomLoot(ArrayList<Movable> newContents, int maxAmount)
	{
		int randomLootAmount = floor(random(maxAmount / 2, maxAmount));

		for(int i = 0; i < randomLootAmount; i++)
		{
			int lootType = floor(random(3));
			ScorePickUp scorePickUp = null;

			if(lootType == 0)
			{
				scorePickUp = new ScorePickUp(IRON_VALUE, ResourceManager.getImage("IronPickUp"));
			}
			else if(lootType == 1)
			{
				scorePickUp = new ScorePickUp(GOLD_VALUE, ResourceManager.getImage("GoldPickUp"));
			}
			else if(lootType == 2)
			{
				scorePickUp = new ScorePickUp(DIAMOND_VALUE, ResourceManager.getImage("DiamondPickUp"));
			}

			load(scorePickUp);
			newContents.add(scorePickUp);
		}
	}

	void pushed(Movable movable, float x, float y)
	{
		super.pushed(movable, x, y);

		if(!opened && movable.canPlayerInteract())
		{
			openChest();
		}
	}

	void takeDamage(float damageTaken)
	{
		super.takeDamage(damageTaken);
		delete(this);
	}

	void openChest()
	{
		AudioManager.playSoundEffect("ChestOpen");

		for (Movable movable : contents)
		{
			//println("Dropping: " + movable);

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
