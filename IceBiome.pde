class IceBiome extends Biome
{
	IceBiome()
	{
		destroyedImage = ResourceManager.getImage("DestroyedIce");
		ceilingObstacleChance = 0.1;
		caveSpawningPossibilityScale = 0.60;
		enemyChance = 0.03;
	}

	Tile getTileToGenerate(int x, int depth)
	{
		
		if(spawnResourceTileAllowed(x, depth))
		{
			float oreChange = random(100);

			if (depth - startedAt < 50)
			{
				if (oreChange <= 4)
				{
					return new GreenIceTile(x, depth);
				}
				else if (oreChange > 4 && oreChange <= 8)
				{
					return new RedIceTile(x, depth);
				}
				else if (oreChange > 8 && oreChange <= 12)
				{
					return new BlueIceTile(x, depth);
				}
				else if (oreChange > 12 && oreChange <= 14)
				{
					return new ExplosionTile(x, depth);
				}
			}
		}
		
		return new IceTile(x, depth);
	}

	String getParallaxedRock()
	{
		return "IceTile";
	}
}
