class Chest extends Obstacle
{
	boolean opened = false;
	int forcedKey = -1; //set to something zero or above if you want a specific set of contents

	float jumpiness = -35; //how far our contents jump out
	float sideWobble = 5; //vertical velocity of item ranging between -sideWobble and sideWobble

	PImage openState = ResourceManager.getImage("ChestOpen");

	ArrayList<Movable> contents = new ArrayList<Movable>();

	Chest(int forcedKey)
	{

		if(forcedKey > 0)
		{
			this.forcedKey = forcedKey;
		}

		populateContents();
		anchored = false;

		image = ResourceManager.getImage("Chest");
	}

	// only load childtypes of Movable
	void populateContents()
	{
		ArrayList<BaseObject> newContents = new ArrayList<BaseObject>();

		int randomKey = int(random(1, 3));

		if (forcedKey >= 0)
		{
			randomKey = forcedKey;
		}

		switch(randomKey)
		{
			case 1:
				newContents.add(load(new RelicShard(), new PVector(200, 200)));
				addRandomLoot(newContents, 12);
			break;

			case 2:
				for (int i = 0; i < 3; i++) {
				newContents.add(load(new Dynamite(), new PVector(200, 200)));
				}

				addRandomLoot(newContents, 12);
			break;

			case 69:
				newContents.add(load(new Pickaxe(), new PVector(200, 200)));
				//please don't remove this for relic testing
			case 70:
				newContents.add(load(new RelicShard(), new PVector(200, 200)));
				addRandomLoot(newContents, 6);
			break;
		}

		// I dont want to force every new content thingy to Movable seperately, so do it here
		for (BaseObject object : newContents)
		{
			contents.add((Movable) object);
		}

		for (Movable movable : contents)
		{
			movable.suspended = true;
		}
	}

	void addRandomLoot(ArrayList<BaseObject> newContents, int maxAmount)
	{
		int randomLootAmount = (int) random(maxAmount / 2, maxAmount);

		for(int i = 0; i < randomLootAmount; i++)
		{
			int lootType = (int) random(3);

			switch (lootType)
			{
				case 0:
				// iron
					newContents.add(load(new ScorePickUp(Globals.IRONVALUE, ResourceManager.getImage("IronPickUp")), new PVector(200, 200)));
				break;

				case 1:
				// gold
					newContents.add(load(new ScorePickUp(Globals.GOLDVALUE, ResourceManager.getImage("GoldPickUp")), new PVector(200, 200)));
				break;

				case 2:
				// diamond
					newContents.add(load(new ScorePickUp(Globals.DIAMONDVALUE, ResourceManager.getImage("DiamondPickUp")), new PVector(200, 200)));
				break;
			}
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
			movable.position.set(new PVector(position.x, position.y - Globals.TILE_SIZE));
			movable.suspended = false;

			movable.velocity.y = random(jumpiness / 4, jumpiness);
			movable.velocity.x = random(-sideWobble, sideWobble);
		}

		contents.clear();
		opened = true;
		image = openState;
	}
}
