ArrayList<Atom> atomList = new ArrayList<Atom>();
ArrayList<Tile> tileList = new ArrayList<Tile>();
ArrayList<ArrayList<Tile>> map = new ArrayList<ArrayList<Tile>>();//2d list with x, y and Tile.

Mob user;
WallOfDeath lava; 

int tilesHorizontal = 50;
int tilesVertical = 50;
int tileWidth = 50;
int tileHeight = 50;

int safeZone = 10;

void setup() {
  size(1280, 720, P2D);
  tileList.add(new Tile(100, 100));

  Player player = new Player();
  atomList.add(player);
  user = player;

  lava = new WallOfDeath(tilesHorizontal * tileWidth + tileWidth);
  atomList.add(lava);

  generateTiles();
}

void draw() {
  background(255, 255, 255);

  float xScroll = -user.position.x + width * 0.5 - user.size.x / 2;
  float yScroll = -user.position.y + height * 0.5 - user.size.y / 2;

  translate(constrain(xScroll, -1270, 0), yScroll);

  for (Tile tile : tileList) {
    tile.update();
    tile.draw();
  }
  
  for (Atom atom : atomList) {
    atom.update();
    atom.draw();
  }
  
  lava.checkIfPlayerHit(user); 
}

Tile getTile(int x, int y){ //return tile you're currently on
  ArrayList<Tile> subList = map.get(constrain(y / tileHeight, 0, tilesVertical));
  
  return subList.get(constrain(x / tileWidth, 0, tilesHorizontal));
}

ArrayList<Tile> getSurroundingTiles(int x, int y, Atom collider, CollisionTypes cType){ //return an arrayList with the four surrounding tiles of the coordinates
  ArrayList<Tile> surrounding = new ArrayList<Tile>();
  
  int middleX = int(x + collider.size.x * .5); //calculate from the middle, because it's the average of all our colliding corners
  int middleY = int(y + collider.size.y * .5);
  
  int cWidth = tileWidth; //floor(collider.size.x);
  int cHeight = tileHeight; //floor(collider.size.y);
  
  if(cType == CollisionTypes.ALL || cType == CollisionTypes.UP){
    surrounding.add(getTile(middleX, middleY - cHeight));
    
    //up diagonals
    surrounding.add(getTile(middleX - cWidth, middleY - cHeight));
    surrounding.add(getTile(middleX + cWidth, middleY - cHeight));
  }
  
  else if(cType == CollisionTypes.ALL || cType == CollisionTypes.DOWN){
    surrounding.add(getTile(middleX, middleY + cHeight));
    
    //down diagonals
    surrounding.add(getTile(middleX + cWidth, middleY + cHeight));
    surrounding.add(getTile(middleX - cWidth, middleY + cHeight));
    
  }
  
  else if(cType == CollisionTypes.ALL || cType == CollisionTypes.HORIZONTAL){
    surrounding.add(getTile(middleX - cWidth, middleY));
    surrounding.add(getTile(middleX + cWidth, middleY)); 
    
    //all diagonals
    surrounding.add(getTile(middleX + cWidth, middleY + cHeight));
    surrounding.add(getTile(middleX - cWidth, middleY + cHeight));
    surrounding.add(getTile(middleX - cWidth, middleY - cHeight));
    surrounding.add(getTile(middleX + cWidth, middleY - cHeight));
  }
  return surrounding;
}

enum CollisionTypes {
  UP,
  DOWN,
  HORIZONTAL, //we really don't care about left or right
  ALL
}
