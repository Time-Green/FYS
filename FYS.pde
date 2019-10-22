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
int backcolor = #87CEFA;

void setup() {
  ResourceManager.setup(this);
  loadResources();

  size(1280, 720, P2D);
  frameRate(60);
  smooth(4);
  tileList.add(new Tile(100, 100));

  Player player = new Player();
  atomList.add(player);
  user = player;

  lava = new WallOfDeath(tilesHorizontal * tileWidth + tileWidth);
  atomList.add(lava);

  generateTiles();
}

void draw() {
  background(backcolor);

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

void loadResources() {
  //player
  ResourceManager.load("player", "player.jpg");
  //ores and stones
  ResourceManager.load("GrassBlock", "grass.block.jpg");
  ResourceManager.load("DirtBlock", "dirt.block.jpg");
  ResourceManager.load("StoneBlock", "stone.block.jpg");
  ResourceManager.load("coalBlock", "coal.block.jpg");
  ResourceManager.load("ironBlock", "iron.block.jpg");
  ResourceManager.load("goldBlock", "gold.block.jpg");
  ResourceManager.load("diamondBlock", "diamond.block.jpg");
  ResourceManager.load("bedrockBlock", "bedrock.block.jpg");
}

Tile getTile(int x, int y) { //return tile you're currently on
  ArrayList<Tile> subList = map.get(constrain(y / tileHeight, 0, tilesVertical));

  return subList.get(constrain(x / tileWidth, 0, tilesHorizontal));
}

ArrayList<Tile> getSurroundingTiles(int x, int y, Atom collider) { //return an arrayList with the four surrounding tiles of the coordinates
  ArrayList<Tile> surrounding = new ArrayList<Tile>();

  int middleX = int(x + collider.size.x * .5); //calculate from the middle, because it's the average of all our colliding corners
  int middleY = int(y + collider.size.y * .5);

  int cWidth = tileWidth; //floor(collider.size.x);
  int cHeight = tileHeight; //floor(collider.size.y);

  //cardinals
  surrounding.add(getTile(middleX, middleY - cHeight));
  surrounding.add(getTile(middleX, middleY + cHeight));
  surrounding.add(getTile(middleX - cWidth, middleY));
  surrounding.add(getTile(middleX + cWidth, middleY)); 

  //diagonals
  surrounding.add(getTile(middleX + cWidth, middleY + cHeight));
  surrounding.add(getTile(middleX - cWidth, middleY + cHeight));
  surrounding.add(getTile(middleX - cWidth, middleY - cHeight));
  surrounding.add(getTile(middleX + cWidth, middleY - cHeight));
  return surrounding;
}
