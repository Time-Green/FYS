class NormalBiome extends Biome { //the default biome, almost identical to the Biome class itself

  NormalBiome() {
    structureChance = 0.2;
  }

  String getStructureName() {
    return "Dungeon";
  }
  
}
