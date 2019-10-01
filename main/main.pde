ArrayList<Atom> atomList = new ArrayList<Atom>();
ArrayList<Tile> tileList = new ArrayList<Tile>();

int tilesHorizontal = 50;
int tilesVertical = 50;
int tileWidth = 50;
int tileHeight = 50;

int safeZone = 10;

void setup(){
  fullScreen(P2D);
  background(255,255,255);
  tileList.add(new Tile(100, 100));
  atomList.add(new Player());
  generateTiles();
}

void draw(){
  for(Atom atom : atomList){
    atom.process();
  }
  for(Tile tile : tileList){
    tile.process();
  }
}
