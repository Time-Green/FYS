class RelicShard extends PickUp
{
	int type;

	RelicShard()
	{
		// 0: mine boost
		// 1: healthboost
		// 2: regenboost
		// 3: speedboost
		// 4: lightboost

		type = floor(random(5));
		image = ResourceManager.getImage("RelicShard" + type);
	}

	void pickedUp(Mob mob)
	{
		super.pickedUp(mob);

		PlayerRelicInventory playerRelicInventory = getRelicShardInventoryByType();

		if(playerRelicInventory == null)
		{
			PlayerRelicInventory newPlayerRelicInventory = new PlayerRelicInventory();

			newPlayerRelicInventory.relicshardid = type;
			newPlayerRelicInventory.amount = 1;

			totalCollectedRelicShards.add(newPlayerRelicInventory);
		}
		else
		{
			playerRelicInventory.amount++;
		}

		runData.collectedRelicShards.add(this);
	}

	PlayerRelicInventory getRelicShardInventoryByType()
	{
		for(PlayerRelicInventory collectedRelicShardInventory : totalCollectedRelicShards)
		{
			if(collectedRelicShardInventory.relicshardid == type)
			{
				return collectedRelicShardInventory;
			}
		}

		return null;
	}
}
