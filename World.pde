public class World {
  ArrayList<ArrayList<Tile>> map = new ArrayList<ArrayList<Tile>>();//2d list with y, x and Tile.
  ArrayList<StructureSpawner> queuedStructures = new ArrayList<StructureSpawner>();
  //TODO: CLEANUP MAP ROWS AFTER ALL TILES IN THE ROW HAVE BEEN DELETED

  float deepestDepth = 0.0f; //the deepest point our player has been. Could definitely be a player variable, but I decided against it since it feels more like a global score
  int generateOffset = 25; // generate tiles 15 tiles below player, other 10 are air offset

  PImage dayNightImage;

  float wallWidth;

  Biome[] biomes = {new NormalBiome(), new HollowBiome(), new IceBiome(), new ShadowBiome(), new FireBiome()};
  Biome currentBiome;
  ArrayList<Biome> biomeQueue = new ArrayList<Biome>(); //queue the biomes here
  int switchDepth; //the depth at wich we switch to the next biome in the qeueu

  World(float wallWidth) {
    this.wallWidth = wallWidth;
    dayNightImage = ResourceManager.getImage("DayNightCycle" + floor(random(0, 8)));

    //Specially queued biomes, for cinematic effect
    biomeQueue.add(new OverworldBiome());
    // biomeQueue.add(new NormalBiome());
    biomeQueue.add(new WaterBiome());

    fillBiomeQueue(0);
    switchBiome(0);

    updateWorldDepth();

    spawnOverworldStructures();
    spawnBirds();
    spawnNpcs();
    spawnStarterChest();
  }

  public void update() {
  }

  public void draw() {
    drawBackgoundImage();
    //println("map.size(): " + map.size());
  }

  void drawBackgoundImage(){
    pushMatrix();

    scale(1.1, 1.1);

    float xPos = -camera.position.x - 1080 * 0.1;
    float yPos = -camera.position.y * 0.5 - 200;

    image(dayNightImage, xPos, yPos, wallWidth, 1080);

    popMatrix(); 
  }

  void spawnOverworldStructures() {

    int lastSpawnX = -4;
    final int MIN_DISTANCE_INBETWEEN_TREE = 4;
    final int MAX_XSPAWNPOS = tilesHorizontal - 13;

    for (int i = 1; i < MAX_XSPAWNPOS; i++) {

      if (random(1) < 0.35f && i > lastSpawnX + MIN_DISTANCE_INBETWEEN_TREE) {
        lastSpawnX = i;
        spawnTree(new PVector(i, 6));
      }
    }

    spawnStructure("ButtonAltar", new PVector(40, 8));
  }

  void spawnTree(PVector location){
    spawnStructure("Tree", location); 
  }

  void spawnBirds() {
    for (int i = 0; i < birdCount; i++) {
      Bird bird = new Bird(this);

      load(bird);
    }
  }

  // spawn devs
  void spawnNpcs() {

    String[] names = loadStrings("Texts/NpcNames.txt");
    String[] genericTexts = loadStrings("Texts/GenericTexts.txt");
    String[] panicTexts = loadStrings("Texts/PanicTexts.txt");

    for (int i = 0; i < 6; i++) {
      String[] personalTexts = loadStrings("Texts/" + names[i] + "Texts.txt");

      Npc npc = new Npc(this, names[i], genericTexts, panicTexts, personalTexts);

      load(npc, new PVector(random(50, 1650), 509));
    }
  }

  void spawnStarterChest() {
    load(new Chest(69), new PVector(36 * tileSize, 10 * tileSize)); //69 is the forcedKey for an always pickaxe spawn
  }

  //return tile you're currently on
  Tile getTile(float x, float y) {

    int yGridPos = floor(y / tileSize);

    if (yGridPos < 0 || yGridPos > map.size() - 1) {
      return null;
    }

    ArrayList<Tile> subList = map.get(yGridPos); //map.size() instead of tilesVertical, because the value can change and map.size() is always the most current

    int xGridPos = floor(x / tileSize);

    if (xGridPos < 0 || xGridPos >= subList.size()) {
      return null;
    }

    return subList.get(xGridPos);
  }

  void updateWorldDepth() {

    int mapDepth = map.size();

    int playerDepth = Globals.OVERWORLDHEIGHT;

    if(player != null){
      playerDepth = player.getDepth();
    }

    for (int y = mapDepth; y <= playerDepth + generateOffset; y++) {

      ArrayList<Tile> subArray = new ArrayList<Tile>(); //make a list for the tiles

      if (canBiomeSwitch(y)) {
        switchBiome(y);
      }

      if (currentBiome.structureChance > random(1)) {
        currentBiome.placeStructure(this, y);
      }

      for (int x = 0; x <= tilesHorizontal; x++) {
        Tile tile = currentBiome.getTileToGenerate(x, y);
        tile.destroyedImage = currentBiome.destroyedImage;

        subArray.add(tile);
        load(tile, true);

        tile.setupCave(this); //needs to be after load(tile) otherwise shit will get loaded anyway
      }

      map.add(subArray);// add the empty tile-list to the bigger list
    }

    for (StructureSpawner spawner : queuedStructures) {
      spawner.trySpawn(this);
    }
  }

  //returns an arraylist with the 8 tiles surrounding the coordinations. returns BaseObjects so that it can easily be joined with every object list
  //but it's still kinda weird I'll admit
  ArrayList<BaseObject> getSurroundingTiles(float x, float y, Movable collider) { 
    ArrayList<BaseObject> surrounding = new ArrayList<BaseObject>();

    float middleX = x + collider.size.x * 0.5f; //calculate from the middle, because it's the average of all our colliding corners
    float middleY = y + collider.size.y * 0.5f;

    //cardinals
    Tile topTile = getTile(middleX, middleY - tileSize);
    if (topTile != null) {
      surrounding.add(topTile);
    }

    Tile botTile = getTile(middleX, middleY + tileSize);
    if (botTile != null) {
      surrounding.add(botTile);
    }

    Tile leftTile = getTile(middleX - tileSize, middleY);
    if (leftTile != null) {
      surrounding.add(leftTile);
    }

    Tile rightTile = getTile(middleX + tileSize, middleY);
    if (rightTile != null) {
      surrounding.add(rightTile);
    }

    //diagonals
    Tile botRightTile = getTile(middleX + tileSize, middleY + tileSize);
    if (botRightTile != null) {
      surrounding.add(botRightTile);
    }

    Tile botLeftTile = getTile(middleX - tileSize, middleY + tileSize);
    if (botLeftTile != null) {
      surrounding.add(botLeftTile);
    }

    Tile topLeftTile = getTile(middleX - tileSize, middleY - tileSize);
    if (topLeftTile != null) {
      surrounding.add(topLeftTile);
    }

    Tile topRightTile = getTile(middleX + tileSize, middleY - tileSize);
    if (topRightTile != null) {
      surrounding.add(topRightTile);
    }

    return surrounding;
  }

  ArrayList<Tile> getTilesInRadius (PVector pos, float radius) {
    ArrayList<Tile> returnList = new ArrayList<Tile>();
    for (Tile tile : tileList) {

      if (dist(pos.x, pos.y, tile.position.x, tile.position.y) < radius) {
        returnList.add(tile);
      }
    }

    return returnList;
  }

  void updateDepth() { //does some stuff related to the deepest depth, currently only infinite generation
    float depth = player.getDepth();

    if (depth > deepestDepth) { //check if we're on a generation point and if we have not been there before
      updateWorldDepth();
      deepestDepth = depth;
    }
  }

  ArrayList<Tile> getLayer(int layer) {
    return map.get(layer);
  }

  PVector getGridPosition(Movable movable) {//return the X and Y in tiles
    return new PVector(floor(movable.position.x / tileSize), floor(movable.position.y / tileSize));
  }

  float getWidth() {
    return tilesHorizontal * tileSize;
  }

  boolean canBiomeSwitch(int depth) {
    return depth > switchDepth;
  }

  void switchBiome(int depth) {
    if (biomeQueue.size() != 0) {
      currentBiome = biomeQueue.get(0);
      switchDepth += currentBiome.length;
      biomeQueue.remove(0);
      currentBiome.startedAt = depth;
    } else {
      fillBiomeQueue(depth);
    }
  }

  void fillBiomeQueue(int depth) {
    for (int i = 0; i < 10; i++) {
      ArrayList<Biome> possibleBiomes = new ArrayList<Biome>();

      for (Biome biome : biomes) {
        if (biome.minimumDepth > depth || biome.maximumDepth < depth) {
          continue;
        }
        possibleBiomes.add(biome);
      }

      Biome biome;
      if (possibleBiomes.size() > 0) {
        biome = possibleBiomes.get(int(random(possibleBiomes.size())));
      } else {
        biome = biomes[int(random(biomes.length))]; //plan B just grab a random one
      }

      depth += biome.getLength();
      biomeQueue.add(biome);
    }
  }

  void safeSpawnStructure(String structureName, PVector gridSpawnPos) {
    load(new StructureSpawner(this, structureName, gridSpawnPos), gridSpawnPos.mult(tileSize));
  }

  void spawnStructure(String structureName, PVector gridSpawnPos) {

    JSONArray layers = loadJSONArray(dataPath("Structures\\" + structureName + ".json"));

    for (int layerIndex = 0; layerIndex < layers.size(); layerIndex++) {

      JSONArray tiles = layers.getJSONArray(layerIndex);
      String[] tileValues = tiles.getStringArray();

      for (String tileString : tileValues) {

        String[] tileProperties = split(tileString, '|');

        if (tileProperties.length == 3) {

          String tileXPos = tileProperties[0];
          String tileYPos = tileProperties[1];
          String tileType = tileProperties[2];

          PVector structureTilePosition = new PVector(int(tileXPos), int(tileYPos));

          PVector worldTilePosition = new PVector();
          worldTilePosition.add(gridSpawnPos);
          worldTilePosition.add(structureTilePosition);

          // if layerIndex == 0 (background) replace the existing tile
          //else if layerIndex > 1, spawn on top of other tile (used for enemies, torch)
          if (layerIndex == 0) {
            replaceObject(worldTilePosition, tileType);
          } else {
            spawnObject(worldTilePosition, tileType);
          }
        }
      }
    }
  }

  private void replaceObject(PVector relaceAtGridPos, String newObjectName) {
    Tile tileToReplace = getTile(relaceAtGridPos.x * tileSize, relaceAtGridPos.y * tileSize);

    String stripedObjectName = stripName(newObjectName);
    Tile newTile = convertNameToTile(stripedObjectName, relaceAtGridPos);
    tileToReplace.replace(this, newTile);
  }

  private void spawnObject(PVector spawnAtGridPos, String newObjectName) {

    String stripedObjectName = stripName(newObjectName);

    spawnObjectByName(stripedObjectName, spawnAtGridPos);
  }

  private String stripName(String fullNamePath) {
    String[] objectPathSplit = split(fullNamePath, '\\');
    String stripedObjectName = objectPathSplit[objectPathSplit.length - 1].replace(".png", "").replace(".jpg", "");

    return stripedObjectName;
  }

  private Tile convertNameToTile(String stripedObjectName, PVector spawnPos) {

    switch(stripedObjectName) {

    case "DestroyedBlock" :
      Tile destroyedStoneTile = new StoneTile(int(spawnPos.x), int(spawnPos.y));
      destroyedStoneTile.mine(false);
      return destroyedStoneTile;

    case "WoodPlank" :
      return new WoodPlankTile(int(spawnPos.x), int(spawnPos.y));

    case "DoorTop" :
      return new DoorTopTile(int(spawnPos.x), int(spawnPos.y));

    case "DoorBot" :
      return new DoorBotTile(int(spawnPos.x), int(spawnPos.y));

    case "Glass" :
      return new GlassTile(int(spawnPos.x), int(spawnPos.y));

    case "Leaf" :
      return new LeafTile(int(spawnPos.x), int(spawnPos.y));

    case "Wood" :
      return new WoodTile(int(spawnPos.x), int(spawnPos.y));

    case "WoodBirch" :
      return new WoodBirchTile(int(spawnPos.x), int(spawnPos.y));

    case "MagmaTile" :
      return new MagmaRock(int(spawnPos.x), int(spawnPos.y));

    case "ObsedianBlock" :
      return new ObsedianTile(int(spawnPos.x), int(spawnPos.y)); //obsedian

    case "DungeonBlock0" :
      return new DungeonBlock0(int(spawnPos.x), int(spawnPos.y));

    case "DungeonBlock1" :
      return new DungeonBlock1(int(spawnPos.x), int(spawnPos.y));

    case "DungeonBlock2" :
      return new DungeonBlock2(int(spawnPos.x), int(spawnPos.y));

    case "DungeonStairL" :
      return new DungeonStairL(int(spawnPos.x), int(spawnPos.y));

    case "DungeonStairR" :
      return new DungeonStairR(int(spawnPos.x), int(spawnPos.y));
    }

    println("ERROR: structure tile '" + stripedObjectName + "' not set up or not found!");
    return new AirTile(int(spawnPos.x), int(spawnPos.y));
  }

  private void spawnObjectByName(String stripedObjectName, PVector spawnAtGridPos) {

    PVector spawnWorldPos = new PVector();
    spawnWorldPos.set(spawnAtGridPos);
    spawnWorldPos.x *= tileSize;
    spawnWorldPos.y *= tileSize;

    switch(stripedObjectName) {

    case "Torch" :
      load(new Torch(), spawnWorldPos);
      break;

    case "BombEnemy" :
      load(new EnemyBomb(spawnWorldPos));
      break;

    case "Chest" :
      load(new Chest(0), spawnWorldPos);
      break;

    case "Button" :
      load(new Button(), spawnWorldPos);
      break;

    case "Banner" :
      load(new Banner(), spawnWorldPos);
      break;

    case "Art0" :
      load(new Art0(), spawnWorldPos);
      break;

    case "Art1" :
      load(new Art1(), spawnWorldPos);
      break;

    case "ChairL" :
      load(new ChairL(), spawnWorldPos);
      break;

    case "ChairR" :
      load(new ChairR(), spawnWorldPos);
      break;

    case "Skull" :
      load(new Skull(), spawnWorldPos);
      break;

    case "SkullTorch" :
      load(new SkullTorch(), spawnWorldPos);
      break;

    case "Cobweb" :
      load(new Cobweb(), spawnWorldPos);
      break;

    case "Shelf0" :
      load(new Shelf0(), spawnWorldPos);
      break;

    case "Shelf1" :
      load(new Shelf1(), spawnWorldPos);
      break;

    case "Table" :
      load(new Table(), spawnWorldPos);
      break;

    default :
      println("ERROR: structure object '" + stripedObjectName + "' not set up or not found!");
      break;
    }
  }
}
