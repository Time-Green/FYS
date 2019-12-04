public class World {
  ArrayList<ArrayList<Tile>> map = new ArrayList<ArrayList<Tile>>();//2d list with y, x and Tile.
  ArrayList<StructureSpawner> queuedStructures = new ArrayList<StructureSpawner>();
  //TODO: CLEANUP MAP ROWS AFTER ALL TILES IN THE ROW HAVE BEEN DELETED

  float deepestDepth = 0.0f; //the deepest point our player has been. Could definitely be a player variable, but I decided against it since it feels more like a global score
  int generateOffset = 25; // generate tiles 15 tiles below player, other 10 are air offset

  int safeZone = 10;

  PImage dayNightImage;

  float wallWidth;

  Biome[] biomes = {new Biome(), new HollowBiome(), new IceBiome(), new ShadowBiome(), new FireBiome()};
  Biome currentBiome;
  ArrayList<Biome> biomeQueue = new ArrayList<Biome>(); //queue the biomes here
  int switchDepth; //the depth at wich we switch to the next biome in the qeueu

  World(float wallWidth){
    this.wallWidth = wallWidth;
    dayNightImage = ResourceManager.getImage("DayNightCycle" + floor(random(0, 8)));

    //Specially queued biomes, for cinematic effect
    biomeQueue.add(new OverworldBiome());
    biomeQueue.add(new Biome());

    fillBiomeQueue(0);
    switchBiome(0);
  }

  public void update(){
  }

  public void draw(Camera camera){
    pushMatrix(); 
    scale(1.1, 1.1);

    float xPos = -camera.position.x - 1080 * 0.1;
    float yPos = -camera.position.y * 0.5 - 200;

    image(dayNightImage, xPos, yPos, wallWidth, 1080);
    popMatrix(); 
    //println("map.size(): " + map.size());
  }

  //return tile you're currently on
  Tile getTile(float x, float y){

    int yGridPos = floor(y / tileWidth);

    if(yGridPos < 0 || yGridPos > map.size() - 1){
      return null;
    }

    ArrayList<Tile> subList = map.get(yGridPos); //map.size() instead of tilesVertical, because the value can change and map.size() is always the most current

    // if(subList.size() == 0){
    //   return null;
    // }

    int xGridPos = floor(x / tileWidth);

    if(xGridPos < 0 || xGridPos >= subList.size()){
      return null;
    }

    return subList.get(xGridPos);
  }

  void updateWorldDepth() {

    int mapDepth = map.size();
    

    for(int y = mapDepth; y <= player.getDepth() + generateOffset; y++){

      ArrayList<Tile> subArray = new ArrayList<Tile>(); //make a list for the tiles

      if(canBiomeSwitch(y)){
        switchBiome(y);
      }

      if(currentBiome.structureChance > random(1)){
        currentBiome.placeStructure(y);
      }

      for(int x = 0; x <= tilesHorizontal; x++){
        Tile tile = currentBiome.getTileToGenerate(x, y);
        tile.destroyedImage = currentBiome.destroyedImage;
        
        subArray.add(tile);
        load(tile, true);

        tile.setupCave(); //needs to be after load(tile) otherwise shit will get loaded anyway 
      }
      
      map.add(subArray);// add the empty tile-list to the bigger list
    }

    for(StructureSpawner spawner : queuedStructures){
      spawner.trySpawn();
    }
  }

//returns an arraylist with the 8 tiles surrounding the coordinations. returns BaseObjects so that it can easily be joined with every object list
//but it's still kinda weird I'll admit
  ArrayList<BaseObject> getSurroundingTiles(float x, float y, Movable collider) { 
    ArrayList<BaseObject> surrounding = new ArrayList<BaseObject>();

    float middleX = x + collider.size.x * 0.5f; //calculate from the middle, because it's the average of all our colliding corners
    float middleY = y + collider.size.y * 0.5f;

    //cardinals
    Tile topTile = getTile(middleX, middleY - tileHeight);
    if(topTile != null){
      surrounding.add(topTile);
    }

    Tile botTile = getTile(middleX, middleY + tileHeight);
    if(botTile != null){
      surrounding.add(botTile);
    }

    Tile leftTile = getTile(middleX - tileWidth, middleY);
    if(leftTile != null){
      surrounding.add(leftTile);
    }

    Tile rightTile = getTile(middleX + tileWidth, middleY);
    if(rightTile != null){
      surrounding.add(rightTile);
    }

    //diagonals
    Tile botRightTile = getTile(middleX + tileWidth, middleY + tileHeight);
    if(botRightTile != null){
      surrounding.add(botRightTile);
    }

    Tile botLeftTile = getTile(middleX - tileWidth, middleY + tileHeight);
    if(botLeftTile != null){
      surrounding.add(botLeftTile);
    }

    Tile topLeftTile = getTile(middleX - tileWidth, middleY - tileHeight);
    if(topLeftTile != null){
      surrounding.add(topLeftTile);
    }

    Tile topRightTile = getTile(middleX + tileWidth, middleY - tileHeight);
    if(topRightTile != null){
      surrounding.add(topRightTile);
    }

    return surrounding;
  }

  ArrayList<Tile> getTilesInRadius (PVector pos, float radius) {
    ArrayList<Tile> returnList = new ArrayList<Tile>();
    for (Tile tile : tileList) {

      if(dist(pos.x, pos.y, tile.position.x, tile.position.y) < radius) {
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

  ArrayList<Tile> getLayer(int layer){
    return map.get(layer);
  }

  PVector getGridPosition(Movable movable){//return the X and Y in tiles
    return new PVector(floor(movable.position.x / tileWidth), floor(movable.position.y / tileHeight));
  }

  float getWidth(){
    return tilesHorizontal * tileWidth;
  }

  boolean canBiomeSwitch(int depth){
    return depth > switchDepth;
  }

  void switchBiome(int depth){
    if(biomeQueue.size() != 0){
      currentBiome = biomeQueue.get(0);
      switchDepth += currentBiome.length;
      biomeQueue.remove(0);
      currentBiome.startedAt = depth;
    }
    else{
      fillBiomeQueue(depth);
    }
  }

  void fillBiomeQueue(int depth){
    for(int i = 0; i < 10; i++){
      ArrayList<Biome> possibleBiomes = new ArrayList<Biome>();

      for(Biome biome : biomes){
        if(biome.minimumDepth > depth || biome.maximumDepth < depth){
          continue;
        }
        possibleBiomes.add(biome);
      }

      Biome biome;
      if(possibleBiomes.size() > 0){
        biome = possibleBiomes.get(int(random(possibleBiomes.size())));
      }
      else{
        biome = biomes[int(random(biomes.length))]; //plan B just grab a random one
      }

      depth += biome.getLength();
      biomeQueue.add(biome);
    }
  }

  void safeSpawnStructure(String structureName, PVector gridSpawnPos){
    load(new StructureSpawner(structureName, gridSpawnPos), gridSpawnPos.mult(tileWidth));
  }

  void spawnStructure(String structureName, PVector gridSpawnPos){

    JSONArray layers = loadJSONArray(dataPath("Structures\\" + structureName + ".json"));

    for (int layerIndex = 0; layerIndex < layers.size(); layerIndex++){
    
      JSONArray tiles = layers.getJSONArray(layerIndex);
      String[] tileValues = tiles.getStringArray();

      for (String tileString : tileValues){
        
        String[] tileProperties = split(tileString, '|');

        if(tileProperties.length == 3){
          
          String tileXPos = tileProperties[0];
          String tileYPos = tileProperties[1];
          String tileType = tileProperties[2];

          PVector structureTilePosition = new PVector(int(tileXPos), int(tileYPos));

          PVector worldTilePosition = new PVector();
          worldTilePosition.add(gridSpawnPos);
          worldTilePosition.add(structureTilePosition);

          // if layerIndex == 0 (background) replace the existing tile
          //else if layerIndex > 1, spawn on top of other tile (used for enemies, torch)
          if(layerIndex == 0){
            replaceObject(worldTilePosition, tileType);
          }else{
            spawnObject(worldTilePosition, tileType);
          }
        }
      }
    }
  }

  private void replaceObject(PVector relaceAtGridPos, String newObjectName){
    Tile tileToReplace = getTile(relaceAtGridPos.x * tileWidth, relaceAtGridPos.y * tileHeight);
    
    String stripedObjectName = stripName(newObjectName);
    Tile newTile = convertNameToTile(stripedObjectName, relaceAtGridPos);
    tileToReplace.replace(newTile);
  }

  private void spawnObject(PVector spawnAtGridPos, String newObjectName){

    String stripedObjectName = stripName(newObjectName);

    spawnObjectByName(stripedObjectName, spawnAtGridPos);
  }

  private String stripName(String fullNamePath){
    String[] objectPathSplit = split(fullNamePath, '\\');
    String stripedObjectName = objectPathSplit[objectPathSplit.length - 1].replace(".png", "").replace(".jpg", "");

    return stripedObjectName;
  }

  private Tile convertNameToTile(String stripedObjectName, PVector spawnPos){

    switch(stripedObjectName){

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

      case "MagmaTile" :
        return new MagmaRock(int(spawnPos.x), int(spawnPos.y));

      case "ObsedianBlock" :
        return new ObsedianTile(int(spawnPos.x), int(spawnPos.y)); //obsedian
      case "DungeonBlock1" :
        return new DungeonBlock1(int(spawnPos.x), int(spawnPos.y));
    }

    println("ERROR: structure tile '" + stripedObjectName + "' not set up or not found!");
    return new AirTile(int(spawnPos.x), int(spawnPos.y));
  }

  private void spawnObjectByName(String stripedObjectName, PVector spawnAtGridPos){

    PVector spawnWorldPos = new PVector();
    spawnWorldPos.set(spawnAtGridPos);
    spawnWorldPos.x *= tileWidth;
    spawnWorldPos.y *= tileHeight;

    switch(stripedObjectName){

      case "Torch" :
        load(new Torch(spawnWorldPos));
      break;

      case "BombEnemy" :
        load(new EnemyBomb(spawnWorldPos));
      break;

      case "ChestStart" :
        load(new Chest(), spawnWorldPos);
      break;

      case "Button" :
        load(new Button(), spawnWorldPos);
      break;

      default :
        println("ERROR: structure object '" + stripedObjectName + "' not set up or not found!");
      break;	
    }
  }
}
