class ShadowBiome extends Biome {

  ShadowBiome() {
    enemyChance = 0.1;
    minimumDepth = 200;
    playerVisibility = 350;
    destroyedImage = ResourceManager.getImage("DestroyedShadow");
  }

  Tile getTileToGenerate(int x, int depth) {
    float orechance = random(100);

    if (depth - startedAt < length) {

      if (orechance <= 4) {
        return new GoldTile(x, depth, 1);
      } else if (orechance <= 8) {
        return new DiamondTile(x, depth, 1);
      } else if (orechance <=16) {
        return new ShadowSandTile(x, depth);
      } else if (orechance <=18) {
        return new ObsedianTile(x, depth);
      }
    }

    return new ShadowTile(x, depth);
  }

  void spawnEnemy(PVector position) {
    load(new EnemyGhost(position));
  }
}
