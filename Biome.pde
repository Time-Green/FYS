class Biome {

  int length = 50; //after how many tiles do we tell world to get another biome?

  float structureChance = 0.001; //chance of a structure spawning between 0 and 1 for every row of tiles
  float enemyChance = 0.01; //chance of enemy spawning on an open tile

  int minimumDepth = 0;
  int maximumDepth = 999999;

  float caveSpawningNoiseScale = 0.1f;
  float caveSpawningPossibilityScale = 0.68f; //lower for more caves
  int startedAt;

  //-1 is standard player view
  float playerVisibility = -1;

  PImage destroyedImage = ResourceManager.getImage("DestroyedBlock");

  Tile getTileToGenerate(int x, int depth) {

    // Never spawn resources directly underneath the player, to discourage the player from just digging straight down
    if(player != null && abs(x * tileSize - player.position.x) < tileSize * 3){

      return new StoneTile(x, depth); 
    }

    float orechance = random(100);

    //spawn air at surface
    if (depth <= Globals.OVERWORLDHEIGHT)
    {
      return new AirTile(x, depth);
    } else if (depth <= Globals.OVERWORLDHEIGHT + 1) // 1 layer of grass (layer 11)
    {
      return new GrassTile(x, depth);
    } else if (depth < 15) //spawn 14 layers of dirt
    {
      return new DirtTile(x, depth);
    } else if (depth == 15) // 1 layer of dirt to stone transition
    {
      return new DirtStoneTransitionTile(x, depth);
    } else if (depth > 15 && depth <= 500) { //begin stone layers

      if (orechance > 80 && orechance <= 90)
      {
        return new CoalTile(x, depth);
      } else if (orechance > 90 && orechance <= 98)
      {
        return new IronTile(x, depth);
      } else if (orechance > 98 && orechance <= 100)
      {
        //return new MysteryTile(x, depth);
        //if(random(1) > 0.5){
        return new ExplosionTile(x, depth);
        // }else{
        //   return new HealthTile(x, depth); 
        // }
      }
    } else if (depth > 500) {

      if (orechance > 80 && orechance <= 90)
      {
        return new GoldTile(x, depth, 0);
      } else if (orechance > 90 && orechance <= 97)
      {
        return new DiamondTile(x, depth, 0);
      } else if (orechance > 97 && orechance <= 100)
      {
        return new ObsedianTile(x, depth);
      }
    }

    //if no special tile was selected, spawn stone
    return new StoneTile(x, depth);
  }

  // void checkPlayerAboveTile(){
  //   // Never spwan resources directly underneath the player, to discourage the player from just diggin straight down 
  //   if(player != null && abs(x * tileSize - player.position.x) < tileSize * 3){

    

  //   return new StoneTile(x, depth); 
  //   }
  // }

  int getLength() {
    return length;
  }

  void placeStructure(World world, int depth) {
    world.safeSpawnStructure(getStructureName(), new PVector(int(random(tilesHorizontal * 0.8)), depth)); //times 0.8 because stuff at the complete right usually cant spawn
  }

  String getStructureName() { //a function so we can give some different probabilities
    return "SuperBasicDungeon";
  }

  void spawnEnemy(PVector position) {
    float spawner = random(1);

    if (spawner < .3) {
      load(new EnemyWalker(position));
    } else if (spawner < .6) {
      load(new EnemyBomb(position));
    } else if (spawner < .8) {
      load(new EnemyDigger(position));
    } else if (spawner < .85) { 
      load(new EnemyMimic(position));
    } else { 
      load(new EnemyShocker(position));
    }
  }
}
