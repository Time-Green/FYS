ArrayList<Atom> atomList = new ArrayList<Atom>();
ArrayList<Tile> tileList = new ArrayList<Tile>();
ArrayList<ArrayList<Tile>> map = new ArrayList<ArrayList<Tile>>();//2d list with x, y and Tile.

Mob user;

int tilesHorizontal = 50;
int tilesVertical = 50;
int tileWidth = 50;
int tileHeight = 50;

int safeZone = 10;

WallOfDeath lava;

void setup() {
  size(1280, 720, P2D);
  tileList.add(new Tile(100, 100));

  Mob player = new Player();
  atomList.add(player);
  user = player;

  generateTiles();
  lava = new WallOfDeath();
  //setupWall();
}

void drawGame() {
  lava.draw();
}

void updateGame() {
  lava.update();
}

void draw() {
  background(255, 255, 255);


  
  translate(-user.position.x + width * 0.5 - user.size.x / 2, -user.position.y + height * 0.5);
  //drawWall();
  drawGame();
  updateGame();

  for (Tile tile : tileList) {
    tile.handle();
    tile.draw();
  }
  
  for (Atom atom : atomList) {
    atom.handle();
    atom.draw();
  }
}

Tile getTile(int x, int y){ //return tile you're currently on
  ArrayList<Tile> subList = map.get(constrain(y / tileHeight, 0, tilesVertical));
  
  return subList.get(constrain(x / tileWidth, 0, tilesHorizontal));
}

ArrayList<Tile> getSurroundingTiles(int x, int y){ //return an arrayList with the four surrounding tiles of the coordinates
  ArrayList<Tile> surrounding = new ArrayList<Tile>();
  
  int middleX = int(x + tileWidth * .5); //calculate from the middle, because it's the average of all our colliding corners
  int middleY = int(y + tileHeight * .5);
  
  surrounding.add(getTile(middleX + tileWidth, middleY));
  surrounding.add(getTile(middleX, middleY + tileHeight));
  surrounding.add(getTile(middleX - tileWidth, middleY));
  surrounding.add(getTile(middleX, middleY - tileHeight));
  
  surrounding.add(getTile(middleX + tileWidth, middleY + tileHeight));
  surrounding.add(getTile(middleX + tileWidth, middleY - tileHeight));
  surrounding.add(getTile(middleX - tileWidth, middleY + tileHeight));
  surrounding.add(getTile(middleX - tileWidth, middleY - tileHeight));  

  return surrounding;
}
