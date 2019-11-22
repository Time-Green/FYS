public class World {
  ArrayList<ArrayList<Tile>> map = new ArrayList<ArrayList<Tile>>();//2d list with y, x and Tile.
  //TODO: CLEANUP MAP ROWS AFTER ALL TILES IN THE ROW HAVE BEEN DELETED

  float deepestDepth = 0.0f; //the deepest point our player has been. Could definitely be a player variable, but I decided against it since it feels more like a global score
  int generateOffset = 25; // generate tiles 15 tiles below player, other 10 are air offset

  int safeZone = 10;

  PImage dayNightImage;

  float wallWidth;

  Biome[] biomes = {new Biome(), new HollowBiome()};
  Biome currentBiome;
  ArrayList<Biome> biomeQueue = new ArrayList<Biome>(); //queue the biomes here
  int switchDepth; //the depth at wich we switch to the next biome in the qeueu

  World(float wallWidth){
    this.wallWidth = wallWidth;
    dayNightImage = ResourceManager.getImage("DayNightCycle" + floor(random(0, 8)));

    //Specially queued biomes, for sanity sake
    biomeQueue.add(new Biome());

    fillBiomeQueue();
    switchBiome();
  }

  public void update(){
  }

  public void draw(Camera camera){
    image(dayNightImage, 0, 0, wallWidth, 1080);
    //println("map.size(): " + map.size());
  }

  //return tile you're currently on
  Tile getTile(float x, float y){
    ArrayList<Tile> subList = map.get(constrain(floor(y / tileHeight), 0, map.size() - 1)); //map.size() instead of tilesVertical, because the value can change and map.size() is always the most current

    if(subList.size() == 0){
      return new Tile(0, 0); //return void tile if there's no tile
    }

    return subList.get(constrain(floor(x / tileWidth), 0, subList.size() - 1));
  }

  void updateWorldDepth() {

    int mapDepth = map.size();
    
    for(int y = mapDepth; y <= int((player.getDepth() - 10 * tileHeight) / tileHeight) + generateOffset; y++){
      
      ArrayList<Tile> subArray = new ArrayList<Tile>(); //make a list for the tiles

      if(canBiomeSwitch(y)){
        switchBiome();
      }

      for(int x = 0; x <= tilesHorizontal; x++){
        Tile tile = currentBiome.getTileToGenerate(x, y);
        tile.setupCave();

        subArray.add(tile);
        load(tile);
      }

      map.add(subArray);// add the empty tile-list to the bigger list
    }
  }

//returns an arraylist with the 8 tiles surrounding the coordinations. returns BaseObjects so that it can easily be joined with every object list
//but it's still kinda weird I'll admit
  ArrayList<BaseObject> getSurroundingTiles(float x, float y, Movable collider) { 
    ArrayList<BaseObject> surrounding = new ArrayList<BaseObject>();

    float middleX = x + collider.size.x * 0.5f; //calculate from the middle, because it's the average of all our colliding corners
    float middleY = y + collider.size.y * 0.5f;

    //cardinals
    surrounding.add(getTile(middleX, middleY - tileHeight));
    surrounding.add(getTile(middleX, middleY + tileHeight));
    surrounding.add(getTile(middleX - tileWidth, middleY));
    surrounding.add(getTile(middleX + tileWidth, middleY)); 

    //diagonals
    surrounding.add(getTile(middleX + tileWidth, middleY + tileHeight));
    surrounding.add(getTile(middleX - tileWidth, middleY + tileHeight));
    surrounding.add(getTile(middleX - tileWidth, middleY - tileHeight));
    surrounding.add(getTile(middleX + tileWidth, middleY - tileHeight));

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

  void switchBiome(){
    if(biomeQueue.size() != 0){
      currentBiome = biomeQueue.get(0);
      switchDepth += currentBiome.length;
      biomeQueue.remove(0);
    }
    else{
      fillBiomeQueue();
    }
  }

  void fillBiomeQueue(){
    for(int i = 0; i < 10; i++){
      biomeQueue.add(biomes[int(random(biomes.length))]);
    }
  }

  void spawnStructure(String structureName, PVector gridSpawnPos){

    JSONArray layers = loadJSONArray(dataPath("Structures\\" + structureName + ".json")); //<>//

    for (int layerIndex = 0; layerIndex < layers.size(); layerIndex++){
    
      //println("layerIndex: " + layerIndex);

      JSONArray tiles = layers.getJSONArray(layerIndex);
      String[] tileValues = tiles.getStringArray();

      for (String tileString : tileValues){
        
        String[] tileProperties = split(tileString, '|');

        //println("tileProperties: " + tileProperties.length);

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
    Tile tileToReplace = getTile(relaceAtGridPos.x * tileWidth, relaceAtGridPos.y * tileHeight); //<>//
    //println("relaceAtGridPos: " + relaceAtGridPos.x * tileWidth, relaceAtGridPos.y * tileHeight);
    //println("tileToReplace: " + tileToReplace + ": " + tileToReplace.position.x + "|" + tileToReplace.position.y);

    delete(tileToReplace);
    //tileList.remove(tileToReplace);
    //objectList.remove(tileToReplace);

    String stripedObjectName = stripName(newObjectName);
    Tile newTile = convertNameToTile(stripedObjectName, relaceAtGridPos);
    load(newTile);
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
    }

    println("ERROR: structure tile '" + stripedObjectName + "' not set up or not found!");
    return new AirTile(int(spawnPos.x), int(spawnPos.y));
  }

  private void spawnObjectByName(String stripedObjectName, PVector spawnPos){
    switch(stripedObjectName){

      case "Torch" :
        load(new Torch(spawnPos));
      break;

      case "BombEnemy" :
        load(new EnemyBomb(spawnPos));
      break;

      default :
        println("ERROR: structure object '" + stripedObjectName + "' not set up or not found!");
      break;	
    }
  }
}
