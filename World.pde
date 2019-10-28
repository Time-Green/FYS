public class World{
  ArrayList<Tile> tileList = new ArrayList<Tile>();
  ArrayList<ArrayList<Tile>> map = new ArrayList<ArrayList<Tile>>();//2d list with x, y and Tile.
  
  float deepestDepth = 0.0f; //the deepest point our player has been. Could definitely be a player variable, but I decided against it since it feels more like a global score
  int generationRatio = 5; //every five tiles we dig, we add 5 more

  int safeZone = 10;

  public void update(){
    for(Tile tile : tileList){
      tile.update();
    }
  }

  public void draw(Camera camera){
    for(Tile tile : tileList){
      tile.draw(camera);
    }
  }

  //return tile you're currently on
  Tile getTile(float x, float y){
  ArrayList<Tile> subList = map.get(constrain(int(y) / tileHeight, 0, map.size() - 1)); //map.size() instead of tilesVertical, because the value can change and map.size() is always the most current

  return subList.get(constrain(int(x) / tileWidth, 0, tilesHorizontal));
}

void generateLayers(int layers){

  int mapDepth = map.size();

  for(int y = mapDepth; y <= mapDepth + layers; y++){
    ArrayList<Tile> subArray = new ArrayList<Tile>(); //make a list for the tiles
    map.add(subArray); // add the empty tile-list to the bigger list. We'll fill it a few lines down

    for(int x = 0; x <= tilesHorizontal; x++){
      Tile tile;

      if(y > safeZone){ //temporary open air area
        tile = new Tile(x, y);
      } else {
        tile = new OpenTile(x, y);
      }
      
      subArray.add(tile); 
      tileList.add(tile);
    }
  }
}

ArrayList<Tile> getSurroundingTiles(int x, int y, Atom collider){ //return an arrayList with the four surrounding tiles of the coordinates
    ArrayList<Tile> surrounding = new ArrayList<Tile>();

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

void updateDepth(){ //does some stuff related to the deepest depth, currently only infinite generation
    float depth = player.getDepth();

    if(depth % generationRatio == 0 && depth > deepestDepth){ //check if we're on a generation point and if we have not been there before
      generateLayers(generationRatio);
    }

    deepestDepth = max(depth, deepestDepth);
    }
}
