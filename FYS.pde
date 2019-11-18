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
  ResourceManager.prepareResourceLoading();

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

void keyPressed(){
  InputHelper.onKeyPressed(keyCode, key);
}

void keyReleased(){
  InputHelper.onKeyReleased(keyCode, key);
}
