ArrayList<Atom> atomList = new ArrayList<Atom>();
ArrayList<Tile> tileList = new ArrayList<Tile>();
ArrayList<ArrayList<Tile>> map = new ArrayList<ArrayList<Tile>>();//2d list with x, y and Tile. 

Mob user;

int tilesHorizontal = 50;
int tilesVertical = 50;
int tileWidth = 50;
int tileHeight = 50;

int safeZone = 10;

void setup() {
  fullScreen(P2D);
  tileList.add(new Tile(100, 100));

  Mob player = new Player();
  atomList.add(player);
  user = player;

  generateTiles();
  setupWall();
}

void draw() {
  background(255, 255, 255);
  translate(-user.position.x + width * 0.5 - user.size.x / 2, -user.position.y + height * 0.5);
  drawWall();

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
  surrounding.add(getTile(x + tileWidth, y));
  surrounding.add(getTile(x, y + tileHeight));
  surrounding.add(getTile(x - tileWidth, y));
  surrounding.add(getTile(x, y - tileHeight));
  return surrounding;
}
