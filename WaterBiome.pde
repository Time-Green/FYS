class WaterBiome extends Biome {

  WaterBiome() {
    //structureChance = 0.1;
    // caveSpawningPossibilityScale = 0.51f;
    caveSpawningPossibilityScale = 1;
    enemyChance = 0.0;

    destroyedImage = ResourceManager.getImage("WaterTile");

    minimumDepth = 175;
  }

  Tile getTileToGenerate(int x, int depth) {
   
    // Never spawn resources directly underneath the player, to discourage the player from just digging straight down
    if(player != null && abs(x * tileSize - player.position.x) < tileSize * 4){

      return new WaterTile(x, depth); 
    }
   
    float oreChance = 0.01;
    float tileChange = 0.2;

    if (random(1) < oreChance) {
      return new LapisTile(x, depth);
    } else if (random(1) < tileChange) {
      return new StoneTile(x, depth);
    }else {
      return new WaterTile(x, depth);
    }
  }

//   String getStructureName() {
//     return "MagmaRock" + int(random(3));
//   }

  void spawnEnemy(PVector position) {
    load(new EnemyGhost(position));
  }
}
