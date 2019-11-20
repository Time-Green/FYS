public class World {
  ArrayList<ArrayList<Tile>> map = new ArrayList<ArrayList<Tile>>();//2d list with y, x and Tile.
  Tile voidTile = new Tile(0, 0); //return the void tile if there's no tile

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
  }

  //return tile you're currently on
  Tile getTile(float x, float y){
    ArrayList<Tile> subList = map.get(constrain(int(y) / tileHeight, 0, map.size() - 1)); //map.size() instead of tilesVertical, because the value can change and map.size() is always the most current

    if(subList.size() == 0){
      return voidTile;
    }

    return subList.get(constrain(int(x) / tileWidth, 0, subList.size() - 1));
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

        subArray.add(tile);
        load(tile);
      }

      map.add(subArray);// add the empty tile-list to the bigger list
    }
  }

//returns an arraylist with the 8 tiles surrounding the coordinations. returns BaseObjects so that it can easily be joined with every object list
//but it's still kinda weird I'll admit
  ArrayList<BaseObject> getSurroundingTiles(int x, int y, Movable collider) { 
    ArrayList<BaseObject> surrounding = new ArrayList<BaseObject>();

    int middleX = int(x + collider.size.x * .5); //calculate from the middle, because it's the average of all our colliding corners
    int middleY = int(y + collider.size.y * .5);

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
}
