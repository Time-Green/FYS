class IceBiome extends Biome {

  IceBiome() {

    destroyedImage = ResourceManager.getImage("DestroyedIce");
    ceilingObstacleChance = 0.1;
  }

  Tile getTileToGenerate(int x, int depth) {
    
    // Never spawn resources directly underneath the player, to discourage the player from just digging straight down
    if(player != null && abs(x * tileSize - player.position.x) < tileSize * 3){

      return new IceTile(x, depth); 
    }
    
    float orechance = random(100);
    caveSpawningPossibilityScale = .60;
    enemyChance = 0.03;

    if (depth-startedAt<50 ) {
      if (orechance <=4) {
        return new GreenIceTile(x, depth);
      } else if (orechance <= 8) {
        return new RedIceTile(x, depth);
      } else if (orechance <=12) {
        return new SaphireIceTile(x, depth);
      }
    }

    return new IceTile(x, depth);
  }
}
