class GoldenBiome extends Biome
{
	GoldenBiome()
	{
		destroyedImage = ResourceManager.getImage("DestroyedGolden");

		minimumDepth = 700;

		mossChance = 0;

        caveSpawningPossibilityScale = 0.48f; //lower for more caves
	}

    Tile getTileToGenerate(int x, int depth)
  	{
    	if(spawnResourceTileAllowed(x, depth))
    	{
      		float orechance = random(100);

			if (orechance > 93 && orechance <= 95)
			{
				return new DiamondTile(x, depth, 0);
			}
			else if (orechance > 96 && orechance <= 99)
			{
				return new AmethystTile(x, depth, 0);
			}
        }

        return new TintedTile(x, depth);
    }    
}