ArrayList<Atom> atomList = new ArrayList<Atom>();
ArrayList<Tile> tileList = new ArrayList<Tile>();
ArrayList<ArrayList<Tile>> map = new ArrayList<ArrayList<Tile>>();//2d list with x, y and Tile.

Mob user;
WallOfDeath lava;
Camera camera;

int tilesHorizontal = 50;
int tilesVertical = 50;
int tileWidth = 50;
int tileHeight = 50;

int safeZone = 10;
int backgroundColor = #87CEFA;

int deepestDepth = 0; //the deepest point our player has been. Could definitely be a player variable, but I decided against it since it feels more like a global score
int generationRatio = 5; //every five tiles we dig, we add 5 more

void setup() {
  ResourceManager.setup(this);
  loadResources();

  ResourceManager.getSound("Background").loop();

  size(1280, 720, P2D);
  smooth(4);

  Player player = new Player();
  atomList.add(player);
  user = player;

  lava = new WallOfDeath(tilesHorizontal * tileWidth + tileWidth);
  atomList.add(lava);

  camera = new Camera(player);

  generateLayers(tilesVertical);
}

void draw() {
  background(backgroundColor);
  
  //push and pop are needed so the hud can be correctly drawn
  pushMatrix();

  camera.update();

  for (Tile tile : tileList) {
    tile.update();
    tile.draw(camera);
  }

  for (Atom atom : atomList) {
    atom.update();
    atom.draw();
  }

  lava.checkIfPlayerHit(user);
  updateDepth();

  popMatrix();
  //draw hud below popMatrix();

  text("FPS: " + round(frameRate), 10, 20);
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
  //audio
  ResourceManager.load("Background", "terrariaMusic.mp3");
  ResourceManager.load("DirtBreak", "dirt.wav");
  ResourceManager.load("StoneBreak1", "stone1.wav");
  ResourceManager.load("StoneBreak2", "stone2.wav");
  ResourceManager.load("StoneBreak3", "stone3.wav");
  ResourceManager.load("StoneBreak4", "stone4.wav");
}

Tile getTile(float x, float y) { //return tile you're currently on
  ArrayList<Tile> subList = map.get(constrain(int(y) / tileHeight, 0, map.size() - 1)); //map.size() instead of tilesVertical, because the value can change and map.size() is always the most current

  return subList.get(constrain(int(x) / tileWidth, 0, tilesHorizontal));
}

ArrayList<Tile> getSurroundingTiles(int x, int y, Atom collider) { //return an arrayList with the four surrounding tiles of the coordinates
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

void updateDepth() { //does some stuff related to the deepest depth, currently only infinite generation
  int depth = user.getDepth();

  if (depth % generationRatio == 0 && depth > deepestDepth) { //check if we're on a generation point and if we have not been there before
    generateLayers(generationRatio);
  }

  deepestDepth = max(depth, deepestDepth);
}