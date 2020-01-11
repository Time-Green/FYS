class GoldenBiome extends Biome
{
	GoldenBiome()
	{
        float caveSpawningPossibilityScale = 0.51f; //lower for more caves
	}

    Tile getTileToGenerate(int x, int depth)
  	{
    	if(spawnResourceTileAllowed(x, depth))
    	{
      		float orechance = random(100);

			if (orechance > 88 && orechance <= 93)
			{
				return new RedstoneTile(x, depth, 0);
			}
			else if (orechance > 93 && orechance <= 96)
			{
				return new DiamondTile(x, depth, 0);
			}
			else if (orechance > 96 && orechance <= 98)
			{
				return new AmethystTile(x, depth, 0);
			}
        }

        return new TintedTile(x, depth);
    }    
}