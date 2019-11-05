ArrayList<BaseObject> objectList = new ArrayList<BaseObject>();
ArrayList<BaseObject> destroyList = new ArrayList<BaseObject>();

//These only exists as helpers. All drawing and updating is handled from objectList
ArrayList<Tile> tileList = new ArrayList<Tile>();
ArrayList<Atom> atomList = new ArrayList<Atom>();
ArrayList<Mob> mobList = new ArrayList<Mob>();

World world;
Player player;
Camera camera;
UIController ui;
Enemy[] enemies;

int tilesHorizontal = 50;
int tilesVertical = 50;
int tileWidth = 50;
int tileHeight = 50;

int birdCount = 10;

boolean firstTime = true;
//boolean firstStart = true;

void setup() {
  size(1280, 720, P2D);

  ResourceManager.setup(this);
  prepareResourceLoading();

  CameraShaker.setup(this);
}

void setupGame() {
  objectList.clear();

  ui = new UIController();

  //ResourceManager.getSound("Background").loop();

  world = new World(tilesHorizontal * tileWidth + tileWidth);

  player = new Player();
  objectList.add(player);
  player.specialAdd();

  int enemyLenght = 4;
  enemies = new Enemy[enemyLenght];

  enemies[0] = new WalkEnemy();
  enemies[1] = new DigEnemy();
  enemies[2] = new GhostEnemy();
  enemies[3] = new BombEnemy();

  for (int i = 0; i < enemyLenght; i++) {
    objectList.add(enemies[i]);
  }

  for (int i = 0; i < birdCount; i++) {
    Bird bird = new Bird(world);

    objectList.add(bird);
    bird.specialAdd();
  }

  WallOfDeath wallOfDeath = new WallOfDeath(tilesHorizontal * tileWidth + tileWidth);
  objectList.add(wallOfDeath);
  wallOfDeath.specialAdd();

  CameraShaker.reset();
  camera = new Camera(player);

  world.generateLayers(tilesVertical);
}

void draw() {

  if (!ResourceManager.isLoaded()) {
    handleLoading();

    return;
  }

  //setup game after loading
  if (firstTime) {
    firstTime = false;
    setupGame();
  }

  //push and pop are needed so the hud can be correctly drawn
  pushMatrix();

  CameraShaker.update();
  camera.update();

  world.update();
  world.draw(camera);

  updateObjects();
  drawObjects();

  world.updateDepth();

  popMatrix();
  //draw hud below popMatrix();

  handleGameFlow();

  ui.draw();
}

void updateObjects(){
  for(BaseObject object : destroyList){
    objectList.remove(object);
    object.specialDestroy(); //tiles need to remove themselves from the tilegrid
  }
  destroyList.clear();

  for (BaseObject object : objectList) {
    object.update();
  }
}

void drawObjects(){
  for(BaseObject object : objectList){
    object.draw();
  }
}

void handleGameFlow() {

  switch (Globals.currentGameState) {

    //not much happens yet if we are ingame..
  case InGame:

    break;

  case MainMenu:

    //if we are in the main menu we start the game by pressing enter
    if (keys[ENTER]) {
      startGame();
    }

    break;

  case GameOver:

    //if we died we restart the game by pressing enter
    if (keys[ENTER]) {
      startGame();
      Globals.gamePaused = false;
    }

    break;
  
  case GamePaused:
    //if the game has been paused the player can contineu the game
    if (keys[ENTER]) {
      Globals.gamePaused = false;
      Globals.currentGameState = Globals.GameState.InGame;
    }
    if (keys[17]) {
      startGame();
      Globals.gamePaused = false;
    }
  }
}

void startGame() {
  Globals.gamePaused = false;
  Globals.currentGameState = Globals.GameState.InGame;
  setupGame();
}

void handleLoading() {
  background(0);

  String lastLoadedResource = ResourceManager.loadNext();

  float loadingBarWidth = float(ResourceManager.getCurrentLoadIndex()) / float(ResourceManager.getTotalResourcesToLoad());

  //loading bar
  fill(lerpColor(color(255, 0, 0), color(0, 255, 0), loadingBarWidth));
  rect(0, height - 40, loadingBarWidth * width, 40);

  //loading display
  fill(255);
  textSize(30);
  textAlign(CENTER);
  text("Loaded: " + lastLoadedResource, width / 2, height - 10);
}

void prepareResourceLoading() {
  //Player
  ResourceManager.prepareLoad("player", "Sprites/player.png");
  //Enemies
  ResourceManager.prepareLoad("WalkEnemy", "Sprites/Enemies/WalkEnemyTest.jpg");
  ResourceManager.prepareLoad("DigEnemy", "Sprites/Enemies/DigEnemy.jpg");
  ResourceManager.prepareLoad("BombEnemy", "Sprites/Enemies/bombEnemy.png");
  ResourceManager.prepareLoad("GhostEnemy", "Sprites/Enemies/GhostEnemy.png");
  //Tiles
  ResourceManager.prepareLoad("DestroyedBlock", "Sprites/Blocks/destroyed.png");
  ResourceManager.prepareLoad("GrassBlock", "Sprites/Blocks/grassblock.png");
  ResourceManager.prepareLoad("DirtBlock", "Sprites/Blocks/dirtblock.png");
  ResourceManager.prepareLoad("MossBlock", "Sprites/Blocks/mossblock.png");
  ResourceManager.prepareLoad("StoneBlock", "Sprites/Blocks/stoneblock.png");
  ResourceManager.prepareLoad("CoalBlock", "Sprites/Blocks/coalblock.png");
  ResourceManager.prepareLoad("IronBlock", "Sprites/Blocks/ironblock.png");
  ResourceManager.prepareLoad("GoldBlock", "Sprites/Blocks/goldblock.png");
  ResourceManager.prepareLoad("DiamondBlock", "Sprites/Blocks/diamondblock.png");
  ResourceManager.prepareLoad("LapisBlock", "Sprites/Blocks/lapisblock.png");
  ResourceManager.prepareLoad("RedstoneBlock", "Sprites/Blocks/redstoneblock.png");
  ResourceManager.prepareLoad("AmethystBlock", "Sprites/Blocks/amethystblock.png");
  ResourceManager.prepareLoad("ObsedianBlock", "Sprites/Blocks/obsedianblock.png");
  //special
  ResourceManager.prepareLoad("LavaBlock", "Sprites/Blocks/lavablock.png");
  ResourceManager.prepareLoad("Meteor", "Sprites/meteor.png");
  ResourceManager.prepareLoad("Meteor 2", "Sprites/meteor 2.png");
  ResourceManager.prepareLoad("BedrockBlock", "Sprites/Blocks/bedrock.block.jpg");
  //Animals
  ResourceManager.prepareLoad("BirdFlyingLeft0", "Sprites/Animals/tile018.png");
  ResourceManager.prepareLoad("BirdFlyingLeft1", "Sprites/Animals/tile019.png");
  ResourceManager.prepareLoad("BirdFlyingLeft2", "Sprites/Animals/tile020.png");
  ResourceManager.prepareLoad("BirdFlyingRight0", "Sprites/Animals/tile030.png");
  ResourceManager.prepareLoad("BirdFlyingRight1", "Sprites/Animals/tile031.png");
  ResourceManager.prepareLoad("BirdFlyingRight2", "Sprites/Animals/tile032.png");
  //Day Night Ciycle
  for (int i = 0; i < 8; i++) {
    ResourceManager.prepareLoad("DayNightCycle" + i, "Sprites/DayNightCycle/DayNightCycle" + i + ".png");
  }
  //UI
  ResourceManager.prepareLoad("Heart", "Sprites/heart.png");
  //Fonts
  ResourceManager.prepareLoad("Menufont", "Fonts/mario_kart_f2.ttf");
  //Audio
  //ResourceManager.prepareLoad("Background", "Sound/terrariaMusic.mp3");
  ResourceManager.prepareLoad("DirtBreak", "Sound/dirt.wav");
  ResourceManager.prepareLoad("StoneBreak1", "Sound/stone1.wav");
  ResourceManager.prepareLoad("StoneBreak2", "Sound/stone2.wav");
  ResourceManager.prepareLoad("StoneBreak3", "Sound/stone3.wav");
  ResourceManager.prepareLoad("StoneBreak4", "Sound/stone4.wav");
}