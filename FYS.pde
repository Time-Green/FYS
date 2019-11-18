ArrayList<BaseObject> objectList = new ArrayList<BaseObject>();
ArrayList<BaseObject> destroyList = new ArrayList<BaseObject>(); //destroy and loadList are required, because it needs to be qeued before looping through the objectList,
ArrayList<BaseObject> loadList = new ArrayList<BaseObject>();    //otherwise we get a ConcurrentModificationException

//These only exists as helpers. All drawing and updating is handled from objectList
ArrayList<Tile> tileList = new ArrayList<Tile>();
ArrayList<Movable> movableList = new ArrayList<Movable>();
ArrayList<Mob> mobList = new ArrayList<Mob>();

//list of all objects that emit light
ArrayList<BaseObject> lightSources = new ArrayList<BaseObject>();

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
boolean firstStart = true;

void setup() {
  size(1280, 720, P2D);
  //fullScreen(P2D);

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
  load(player);

  int enemyLenght = 4;
  enemies = new Enemy[enemyLenght];

  enemies[0] = new EnemyWalker();
  enemies[1] = new EnemyDigger();
  enemies[2] = new EnemyGhost();
  enemies[3] = new EnemyBomb();

  for (int i = 0; i < enemyLenght; i++) {
    load(enemies[i]);
  }

  for (int i = 0; i < birdCount; i++) {
    Bird bird = new Bird(world);

    load(bird);
  }

  WallOfDeath wallOfDeath = new WallOfDeath(tilesHorizontal * tileWidth + tileWidth);
  load(wallOfDeath);

  CameraShaker.reset();
  camera = new Camera(player);

  world.updateWorldDepth();
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

void updateObjects() {
  for (BaseObject object : destroyList) {

    //clean up light sources of they are destroyed
    if(lightSources.contains(object)){
      lightSources.remove(object);
    }

    object.destroyed(); //handle some dying stuff, like removing ourselves from our type specific lists
  }
  destroyList.clear();

  for(BaseObject object : loadList){
    object.specialAdd();
  }
  loadList.clear();

  for (BaseObject object : objectList) {
    object.update();
  }
}

void drawObjects() {
  for (BaseObject object : objectList) {
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
    if (InputHelper.isKeyDown(ENTER)){
      startGame();
    }

    break;

  case GameOver:

    //if we died we restart the game by pressing enter
    if (InputHelper.isKeyDown(ENTER)){
      startGame();
      Globals.gamePaused = false;
    }

    break;

  case GamePaused:
    //if the game has been paused the player can contineu the game
    if (InputHelper.isKeyDown(ENTER)){
      Globals.gamePaused = false;
      Globals.currentGameState = Globals.GameState.InGame;
    }
    
    if (InputHelper.isKeyDown('o')){
      startGame();
      Globals.gamePaused = false;
    }
  }
}

void startGame() {
  Globals.gamePaused = false;
  Globals.currentGameState = Globals.GameState.InGame;

  if(firstStart){
    firstStart = false;
  }else{
    setupGame();
  }
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

void load(BaseObject newObject) { //handles all the basic stuff to add it to the processing stuff, so we can easily change it without copypasting a bunch
  loadList.add(newObject); //qeue for loading
}

void load(BaseObject newObject, PVector setPosition){
  loadList.add(newObject);
  newObject.moveTo(setPosition);
}

void delete(BaseObject deletingObject) { //handles removal, call delete(object) to delete that object from the world
  destroyList.add(deletingObject); //queue for deletion
}

void setupLightSource(BaseObject object, float lightEmitAmount, float dimFactor){
  object.lightEmitAmount = lightEmitAmount;
  object.distanceDimFactor = dimFactor;
  lightSources.add(object);
}

void prepareResourceLoading() {
  //Player
  ResourceManager.prepareLoad("player", "Sprites/player.png");
  //Enemies
  ResourceManager.prepareLoad("WalkEnemy", "Sprites/Enemies/WalkEnemyTest.jpg");
  ResourceManager.prepareLoad("Mole", "Sprites/Enemies/mole.png");
  ResourceManager.prepareLoad("Bomb", "Sprites/Enemies/bomb.png");
  ResourceManager.prepareLoad("Ghost", "Sprites/Enemies/ghost.png");
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
  ResourceManager.prepareLoad("MysteryBlock", "Sprites/Blocks/mysteryblock.jpg");
  ResourceManager.prepareLoad("LavaBlock", "Sprites/Blocks/lavablock.png");
  ResourceManager.prepareLoad("TNTBlock", "Sprites/Destruction/TNT.png");
  //Decoration
  ResourceManager.prepareLoad("Torch", "Sprites/Cave/torch.png");
  //Pickup
  ResourceManager.prepareLoad("CoalPickUp", "Sprites/Drops/coaldrop.png");
  ResourceManager.prepareLoad("IronPickUp", "Sprites/Drops/irondrop.png");
  ResourceManager.prepareLoad("GoldPickUp", "Sprites/Drops/golddrop.png");
  ResourceManager.prepareLoad("DiamondPickUp", "Sprites/Drops/diamonddrop.png");
  //destruction
  ResourceManager.prepareLoad("Meteor", "Sprites/Destruction/meteor.png");
  ResourceManager.prepareLoad("Meteor 2", "Sprites/Destruction/meteor 2.png");
  //Cave
  ResourceManager.prepareLoad("Chest", "Sprites/Cave/chest.png");
  ResourceManager.prepareLoad("Torch", "Sprites/Cave/torch.png");
  //Landscape
  ResourceManager.prepareLoad("Leafe", "Sprites/Landscape/leafe.png");
  ResourceManager.prepareLoad("Wood", "Sprites/Landscape/wood.png");
  //House 
  ResourceManager.prepareLoad("Door", "Sprites/House/door.png");
  ResourceManager.prepareLoad("Glass", "Sprites/House/glass.png");
  ResourceManager.prepareLoad("WoodPlank", "Sprites/House/woodplank.png");
  //Animals
  for (int i = 0; i < 3; i++) {
    int imageIndex = 30 + i;
    ResourceManager.prepareLoad("BirdFlying" + i, "Sprites/Animals/tile0" + imageIndex + ".png");
  }
  //Obstacles
  ResourceManager.prepareLoad("Spike", "Sprites/Structures/spike.png");
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
  for(int i = 1; i < 5; i++){
    ResourceManager.prepareLoad("StoneBreak" + i, "Sound/stone" + i + ".wav");
  }
  ResourceManager.prepareLoad("Explosion", "Sound/explosion.wav");
}

void keyPressed(){
  InputHelper.onKeyPressed(keyCode, key);
}

void keyReleased(){
  InputHelper.onKeyReleased(keyCode, key);
}
