class ShadowBiome extends Biome
{

	ShadowBiome()
	{
		enemyChance = 0.15;
		
		mossTint = color(80);
		mossChance = 0.0001;

		minimumDepth = 200;
		playerVisibilityScale = 0.65f;

		destroyedImage = ResourceManager.getImage("DestroyedShadow");
	}

	Tile getTileToGenerate(int x, int depth)
	{
		if(spawnResourceTileAllowed(x, depth))
		{
			float oreChange = random(100);

			if (depth - startedAt < length)
			{
				if (oreChange <= 4)
				{
					return new GoldTile(x, depth, 1);
				}
				else if (oreChange > 4 && oreChange <= 8)
				{
					return new DiamondTile(x, depth, 1);
				}
				else if (oreChange > 8 && oreChange <= 16)
				{
					return new ShadowSandTile(x, depth);
				}
				else if (oreChange > 16 && oreChange <= 18)
				{
					return new ObsedianTile(x, depth);
				}
				else if (oreChange > 18 && oreChange <= 20)
				{
					return new ExplosionTile(x, depth);
				}
				// else if (oreChange > 20 && oreChange <= 28)
				// {
				// 	return new DemonClaw(x, depth);
				// }
			} 
		}

		return new ShadowTile(x, depth);
	}

	void spawnEnemy(PVector position)
	{
		load(new EnemyGhost(position));
	}

	// void spawnDemonClaw(PVector position)
	// {
	// 	load(new DemonClaw(position));
	// }



	String getParallaxedRock()
	{
		return "ShadowSandBlock";
	}
}
