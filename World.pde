public class World {
  ArrayList<ArrayList<Tile>> map = new ArrayList<ArrayList<Tile>>();//2d list with y, x and Tile.
  Tile voidTile = new Tile(0, 0); //return the void tile if there's no tile

  float deepestDepth = 0.0f; //the deepest point our player has been. Could definitely be a player variable, but I decided against it since it feels more like a global score
  int generationRatio = 5; //every five tiles we dig, we add 5 more

  int safeZone = 10;

  PImage dayNightImage;

  float wallWidth;

  final float CAVESPAWNINGNOICESCALE = 0.1f;
  final float CAVESPAWNINGPOSSIBILITYSCALE = 0.68f; //lower for more caves

  World(float wallWidth){
    this.wallWidth = wallWidth;
    dayNightImage = ResourceManager.getImage("DayNightCycle" + floor(random(0, 8)));
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

  void generateLayers(int layers) {

    int mapDepth = map.size();

    for(int y = mapDepth; y <= mapDepth + layers; y++){
      ArrayList<Tile> subArray = new ArrayList<Tile>(); //make a list for the tiles
      map.add(subArray); // add the empty tile-list to the bigger list. We'll fill it a few lines down

      for(int x = 0; x <= tilesHorizontal; x++){
        Tile tile = getTileToGenerate(x, y);

        subArray.add(tile); 
        load(tile);
      }
    }
  }

  Tile getTileToGenerate(int x, int depth){
    float orechance = random(100);
    
    if(depth <= safeZone)
    {
      return new AirTile(x, depth);
    }
    else if (depth <= safeZone + 1)
    {
      return new GrassTile(x, depth);
    }
    else if (depth < 15)
    {
      return new DirtTile(x, depth);
    }
    else if (depth == 15)
    {
      return new DirtStoneTransitionTile(x, depth);
    }
    else if (depth > 15) {

      if (orechance < 80)
      {
        return new StoneTile(x, depth);
      }
      else if (orechance >= 80 && orechance <= 88)
      {
        return new CoalTile(x, depth); 
      }
      else if (orechance >= 98 && orechance <= 100){
        //return new MysteryTile(x, depth);
        return new ExplosionTile(x, depth);
      }
      else
      {
        return new IronTile(x, depth);
      }
    }
    else if (depth < 800) {

      if (orechance >= 94 && orechance <= 97)
      {
        return new GoldTile(x, depth);
      }
      else if (orechance >= 98 && orechance <= 100)
      {
        return new DiamondTile(x, depth);
      }
    }
    else
    {
      return new ObsedianTile(x, depth);
    }

    println("WARNING: tile not found!");

    return new AirTile(x, depth);
  }

//returns an arraylist with the 8 tiles surrounding the coordinations. returns BaseObjects so that it can easily be joined with every object list
//but it's still kinda weird I'll admit
  ArrayList<BaseObject> getSurroundingTiles(int x, int y, Atom collider) { 
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

    if (depth % generationRatio == 0 && depth > deepestDepth) { //check if we're on a generation point and if we have not been there before
      generateLayers(generationRatio);
    }

    deepestDepth = max(depth, deepestDepth);
  }

  ArrayList<Tile> getLayer(int layer){
    return map.get(layer);
  }

  PVector getGridPosition(Atom atom){//return the X and Y in tiles
    return new PVector(floor(atom.position.x / tileWidth), floor(atom.position.y / tileHeight));
  }

  float getWidth(){
    return tilesHorizontal * tileWidth;
  }
}
