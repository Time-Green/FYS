class WaterBiome extends Biome {

  WaterBiome() {
    //structureChance = 0.1;
    caveSpawningPossibilityScale = 0.51f;
    enemyChance = 0.01;

    destroyedImage = ResourceManager.getImage("DestroyedWater");

    minimumDepth = 175;
  }

  Tile getTileToGenerate(int x, int depth) {
   
    // Never spawn resources directly underneath the player, to discourage the player from just digging straight down
    if(player != null && abs(x * tileSize - player.position.x) < tileSize * 4){

      return new WaterTile(x, depth); 
    }
   
    float oreChance = 0.01;

    if (random(1) < oreChance) {
      return new LapisTile(x, depth, 0);
    } else {
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
