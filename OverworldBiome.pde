class OverworldBiome extends Biome
{
	OverworldBiome()
	{
		length = 10;
		destroyedImage = ResourceManager.getImage("Invisible");
		canParallax = false;

		transitWidth = 0; //we dont want air holes in the floor
	}

	Tile getTileToGenerate(int x, int depth)
	{
		return new AirTile(x, depth);
	}
}
