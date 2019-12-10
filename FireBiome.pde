class FireBiome extends Biome {

  FireBiome() {
    structureChance = 0.1;
    caveSpawningPossibilityScale = 0.51f;
    enemyChance = 0.01;

    destroyedImage = ResourceManager.getImage("DestroyedVulcanic");

    minimumDepth = 200;
  }

  Tile getTileToGenerate(int x, int depth) {
   
    // Never spawn resources directly underneath the player, to discourage the player from just digging straight down
    if(player != null && abs(x * tileSize - player.position.x) < tileSize * 4){

      return new VulcanicTile(x, depth); 
    }
   
    float oreChance = 0.01;

    if (random(1) < oreChance) {
      return new EmeraldTile(x, depth);
    } else {
      return new VulcanicTile(x, depth);
    }
  }

  String getStructureName() {
    return "MagmaRock" + int(random(3));
  }
}
