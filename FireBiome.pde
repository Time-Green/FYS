class FireBiome extends Biome
{
	FireBiome()
	{
		structureChance = 0.05f;
		caveSpawningPossibilityScale = 0.51f;
		enemyChance = 0.01f;

		destroyedImage = ResourceManager.getImage("DestroyedVulcanic");

		mossChance = 0;

		minimumDepth = 200;
	}

	Tile getTileToGenerate(int x, int depth)
	{
		if(spawnResourceTileAllowed(x, depth))
		{
			float oreChange = random(100);

			if (oreChange <= 1)
			{
				return new MeteoriteTile(x, depth);
			}
			else if (oreChange > 1 && oreChange <= 3)
			{
				return new ExplosionTile(x, depth);
			}
		}
	
		return new VulcanicTile(x, depth);
	}

	String getStructureName()
	{
		float spawnChance = random(1f);

		if(spawnChance < 0.2f)
		{
			return super.getStructureName();
		}

		return "MagmaRock" + int(random(3));
	}

	String getParallaxedRock()
	{
		if(random(1) < 0.01f)
		{
			return "MeteoriteTile";
		}

		return "VulcanicTile";
	}
}
