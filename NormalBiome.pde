// the default biome, almost identical to the Biome class itself
class NormalBiome extends Biome
{
	NormalBiome()
	{
		structureChance = 0.008;
	}

  NormalBiome() {
    structureChance = 0.02;
  }

  String getStructureName() {
    return "Dungeon2";
  }

  BaseObject spawnGroundObstacle(Tile target)
  {
    return load(new Flower(), target.position);
  }
}
