ArrayList<Atom> atomList = new ArrayList<Atom>();
ArrayList<Tile> tileList = new ArrayList<Tile>();
ArrayList<ArrayList<Tile>> map = new ArrayList<ArrayList<Tile>>();//2d list with x, y and Tile.

import processing.sound.*;
SoundFile file;
String audioName = "terrariaMusic.mp3";
String path;
Mob user;
WallOfDeath lava; 

int tilesHorizontal = 50;
int tilesVertical = 50;
int tileWidth = 50;
int tileHeight = 50;


int safeZone = 10;
int backcolor = #87CEFA;

int deepestDepth = 0; //the deepest point our player has been. Could definitely be a player variable, but I decided against it since it feels more like a global score
int generationRatio = 5; //every five tiles we dig, we add 5 more

void setup() {
path = sketchPath(audioName);
file = new SoundFile(this, path);
file.play();
file.loop();

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

  generateLayers(tilesVertical);
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
  updateDepth();
}

void loadResources() {
  //player
  ResourceManager.load("player", "player.jpg");
  //ores and stones
  ResourceManager.load("GrassBlock", "grass.block.jpg");
  ResourceManager.load("DirtBlock", "dirt.block.jpg");
  ResourceManager.load("StoneBlock", "stone.block.jpg");
  ResourceManager.load("CoalBlock", "coal.block.jpg");
  ResourceManager.load("IronBlock", "iron.block.jpg");
  ResourceManager.load("GoldBlock", "gold.block.jpg");
  ResourceManager.load("DiamondBlock", "diamond.block.jpg");
  ResourceManager.load("BedrockBlock", "bedrock.block.jpg");
}

Tile getTile(float _x, float _y) { //return tile you're currently on
  int x = int(_x);
  int y = int(_y);
  ArrayList<Tile> subList = map.get(constrain(y / tileHeight, 0, map.size() - 1)); //map.size() instead of tilesVertical, because the value can change and map.size() is always the most current

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

void updateDepth() { //does some stuff related to the deepest depth, currently only infinite generation
  int depth = user.getDepth();
  if (depth % generationRatio == 0 && depth > deepestDepth) { //check if we're on a generation point and if we have not been there before
    generateLayers(generationRatio);
  }

  deepestDepth = max(depth, deepestDepth);
}
