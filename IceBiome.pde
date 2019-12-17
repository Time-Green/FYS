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
			float orechance = random(100);

			if (depth - startedAt < 50)
			{
				if (orechance <= 4)
				{
					return new GreenIceTile(x, depth);
				}
				else if (orechance <= 8)
				{
					return new RedIceTile(x, depth);
				}
				else if (orechance <=12)
				{
					return new SaphireIceTile(x, depth);
				}
			}
		}
		
		return new IceTile(x, depth);
	}
}
