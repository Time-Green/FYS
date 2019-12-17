class WaterBiome extends Biome
{
	WaterBiome()
	{
		//structureChance = 0.1;
		caveSpawningPossibilityScale = 0.40f;
		// caveSpawningPossibilityScale = 1;
		enemyChance = 0.0;
		destroyedImage = ResourceManager.getImage("DestroyedWater");
		minimumDepth = 100000000;
	}

	Tile getTileToGenerate(int x, int depth)
	{
		if(spawnResourceTileAllowed(x, depth))
		{
			float oreChance = random(100);

			if (oreChance <=1)
			{
				return new LapisTile(x, depth);
			}
			else if (oreChance <=20)
			{
				return new StoneTile(x, depth);
			}
		}

		return new WaterTile(x, depth);
	}

	void spawnEnemy(PVector position)
	{
		load(new EnemyGhost(position));
	}
}
