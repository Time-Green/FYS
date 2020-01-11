class FireBiome extends Biome
{
	FireBiome()
	{
		structureChance = 0.1;
		caveSpawningPossibilityScale = 0.51f;
		enemyChance = 0.01;

		destroyedImage = ResourceManager.getImage("DestroyedVulcanic");

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
		return "MagmaRock" + int(random(3));
	}

	String getParallaxedRock()
	{
		return "VulcanicTile";
	}
}
