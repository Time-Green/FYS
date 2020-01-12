// the default biome, almost identical to the Biome class itself
class NormalBiome extends Biome
{
	NormalBiome()
	{
		structureChance = 0.002;
		maximumDepth = 400;
	}

	BaseObject spawnGroundObstacle(Tile target)
	{
		return load(new Flower(), target.position);
	}
}
