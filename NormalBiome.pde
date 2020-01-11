// the default biome, almost identical to the Biome class itself
class NormalBiome extends Biome
{
	NormalBiome()
	{
		structureChance = 0.02;
		maximumDepth = 400;
	}

	String getStructureName()
	{
		return "Dungeon";
	}

	BaseObject spawnGroundObstacle(Tile target)
	{
		return load(new Flower(), target.position);
	}
}
