// the default biome, almost identical to the Biome class itself
class NormalBiome extends Biome
{
	NormalBiome()
	{
		structureChance = 0.008;
	}

	String getStructureName()
	{
		return "Dungeon2";
	}
}
