ArrayList<Atom> atomList = new ArrayList<Atom>();

World world;
Player player;
Camera camera;

int tilesHorizontal = 50;
int tilesVertical = 50;
int tileWidth = 50;
int tileHeight = 50;

int backgroundColor = #87CEFA;

UIController ui;

void setupGame(boolean firstTime) {
  atomList.clear();

  ui = new UIController();

  //ResourceManager.getSound("Background").loop();

  world = new World(tilesHorizontal * tileWidth + tileWidth);

  player = new Player();
  atomList.add(player);

  WallOfDeath wallOfDeath = new WallOfDeath(tilesHorizontal * tileWidth + tileWidth);
  atomList.add(wallOfDeath);

  camera = new Camera(player);

  world.generateLayers(tilesVertical);

  if (firstTime) {
    Globals.gamePaused = true;
    Globals.currentGameState = Globals.gameState.menu;
  }
}

void setup() {
  size(1280, 720, P2D);

  ResourceManager.setup(this);
  loadResources();
  setupGame(true);
}

void draw() {
  background(backgroundColor);

  //push and pop are needed so the hud can be correctly drawn
  pushMatrix();

  camera.update();

  world.update();
  world.draw(camera);

  for (Atom atom : atomList) {
    atom.update(world);
    atom.draw();
  }

  world.updateDepth();

  if (keys[ENTER]) {
    Globals.gamePaused = false;

    if (Globals.currentGameState == Globals.gameState.menu) {
      Globals.currentGameState = Globals.gameState.inGame;
      setupGame(false);
    } else if (Globals.currentGameState == Globals.gameState.gameOver) {
      Globals.currentGameState = Globals.gameState.inGame;
      setupGame(true);
    }
  }

  popMatrix();
  //draw hud below popMatrix();

  ui.draw();
}

void loadResources() {
  //player
  ResourceManager.load("player", "Sprites/player.jpg");
  //ores and stones
  ResourceManager.load("DestroyedBlock", "Sprites/Blocks/destroyed.png");
  ResourceManager.load("GrassBlock", "Sprites/Blocks/grassblock.png");
  ResourceManager.load("DirtBlock", "Sprites/Blocks/dirtblock.png");
  ResourceManager.load("MossBlock", "Sprites/Blocks/mossblock.png");
  ResourceManager.load("StoneBlock", "Sprites/Blocks/stoneblock.png");
  ResourceManager.load("CoalBlock", "Sprites/Blocks/coal.block.jpg");
  ResourceManager.load("IronBlock", "Sprites/Blocks/iron.block.jpg");
  ResourceManager.load("GoldBlock", "Sprites/Blocks/gold.block.jpg");
  ResourceManager.load("DiamondBlock", "Sprites/Blocks/diamond.block.jpg");
  ResourceManager.load("BedrockBlock", "Sprites/Blocks/bedrock.block.jpg");

  //Day Night Ciycle
  for (int i = 0; i < 8; i++) {
    ResourceManager.load("DayNightCycle" + i, "Sprites/DayNightCycle/DayNightCycle" + i + ".png");
  }

  //UI
  ResourceManager.load("Heart", "Sprites/heart.png");
  //Font
  ResourceManager.load("Menufont", "Fonts/mario_kart_f2.ttf");
  //audio
  //ResourceManager.load("Background", "Sound/terrariaMusic.mp3");
  ResourceManager.load("DirtBreak", "Sound/dirt.wav");
  ResourceManager.load("StoneBreak1", "Sound/stone1.wav");
  ResourceManager.load("StoneBreak2", "Sound/stone2.wav");
  ResourceManager.load("StoneBreak3", "Sound/stone3.wav");
  ResourceManager.load("StoneBreak4", "Sound/stone4.wav");
}
