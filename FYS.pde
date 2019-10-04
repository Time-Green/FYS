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
}

void draw() {
  background(255, 255, 255);
  translate(-user.position.x + width * 0.5 - user.size.x / 2, -user.position.y + height * 0.5);

  for (Tile tile : tileList) {
    tile.process();
  }
  
  for (Atom atom : atomList) {
    atom.process();
  }
}

Tile getTile(int x, int y){ //return tile you're currently on
  ArrayList<Tile> subList = map.get(x / tileWidth);
  
  return subList.get(y / tileHeight);
}
