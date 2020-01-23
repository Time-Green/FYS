class RelicShard extends Pickup
{
	int type;

	//we got a random relicshard from opening chest in dungeons
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

	//only a mob is allowed to pick this up, the player is a mob
	void pickedUp(Mob mob)
	{
		super.pickedUp(mob);

		PlayerRelicInventory playerRelicInventory = getRelicShardInventoryByType();

		//the player wants to keep relicshards and not lose them after 1 playsession thats why we need a relicinventory
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

	//database stuff we need to sort the relicshards by their type and not randomly throw them everywhere
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
