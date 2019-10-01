ArrayList<Atom> atomList = new ArrayList<Atom>();
ArrayList<Tile> tileList = new ArrayList<Tile>();

Map world = new Map(); //we track all tiles

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
  translate(-user.atomX+width*0.5-user.atomWidth/2, -user.atomY+height*0.5);
  for (Tile tile : tileList) {
    tile.process();
  }
  for (Atom atom : atomList) {
    atom.process();
  }

  checkKeys();
}
