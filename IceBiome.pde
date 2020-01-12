class IceBiome extends Biome
{
	IceBiome()
	{
		destroyedImage = ResourceManager.getImage("DestroyedIce");
		ceilingObstacleChance = 0.1;
		caveSpawningPossibilityScale = 0.60;

		mossChance = 0;
		enemyChance = 0.03;
	}

	Tile getTileToGenerate(int x, int depth)
	{
		
		if(spawnResourceTileAllowed(x, depth))
		{
			float oreChance = random(100);

			if (depth - startedAt < 50)
			{
				if (oreChance <= 4)
				{
					return new GreenIceTile(x, depth);
				}
				else if (oreChance > 4 && oreChance <= 8)
				{
					return new RedIceTile(x, depth);
				}
				else if (oreChance > 8 && oreChance <= 12)
				{
					return new BlueIceTile(x, depth);
				}
				else if (oreChance > 12 && oreChance <= 14)
				{
					return new ExplosionTile(x, depth);
				}
				else if (oreChance > 14 && oreChance <= 20)
				{
					return new SnowTile(x, depth); 
				}
			}
		}
		
		return new IceTile(x, depth);
	}

	void spawnEnemy(PVector position)
	{
		load(new Penguin(position));
	}

	String getParallaxedRock()
	{
		if(random(1) < 0.1)
		{
			return "SnowBlock";
		}

		return "IceTile";
	}

	String getStructureName()
	{
        return "Snow" + int(random(5));
	}
}
