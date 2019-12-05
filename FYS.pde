ArrayList<BaseObject> objectList = new ArrayList<BaseObject>(); //<>//
ArrayList<BaseObject> destroyList = new ArrayList<BaseObject>(); //destroy and loadList are required, because it needs to be qeued before looping through the objectList,
ArrayList<BaseObject> loadList = new ArrayList<BaseObject>();    //otherwise we get a ConcurrentModificationException

//These only exists as helpers. All drawing and updating is handled from objectList
ArrayList<Tile> tileList = new ArrayList<Tile>();
ArrayList<Movable> movableList = new ArrayList<Movable>();
ArrayList<Mob> mobList = new ArrayList<Mob>();

//list of all objects that emit light
ArrayList<BaseObject> lightSources = new ArrayList<BaseObject>();

//database variables
DatabaseManager databaseManager = new DatabaseManager();
DbUser dbUser;
int loginStartTime;

DisposeHandler dh;

World world;
Player player;
WallOfDeath wallOfDeath;
Camera camera;
UIController ui;
Enemy[] enemies;

int tilesHorizontal = 50;
int tilesVertical = 50;
int tileSize = 50;

int birdCount = round(random(10, 15));

boolean hasCalledAfterResourceLoadSetup = false;
boolean startGame = false; //start the game on next tick. needed to avoid concurrentmodificationexceptions

void setup() {
  dh = new DisposeHandler(this);

  size(1280, 720, P2D);
  //fullScreen(P2D);

  databaseManager.beginLogin();

  AudioManager.setup(this);

  ResourceManager.setup(this);
  ResourceManager.prepareResourceLoading();

  CameraShaker.setup(this);
}

void login() {
  databaseManager.login();
}

// gets called when all resources are loaded
void afterResouceLoadingSetup() {
  AudioManager.setMaxAudioVolume("Siren", 0.6f);
  AudioManager.setMaxAudioVolume("BackgroundMusic", 0.75f);
  AudioManager.setMaxAudioVolume("DirtBreak", 0.5f);

  for (int i = 1; i < 5; i++) {
    AudioManager.setMaxAudioVolume("Explosion" + i, 0.2f);
  }

  for (int i = 1; i < 5; i++) {
    AudioManager.setMaxAudioVolume("StoneBreak" + i, 0.5f);
  }

  for (int i = 1; i < 4; i++) {
    AudioManager.setMaxAudioVolume("GlassBreak" + i, 0.4f);
  }

  //setup game and show title screen
  setupGame();
}

void setupGame() {
  objectList.clear();

  ui = new UIController();

  world = new World(tilesHorizontal * tileSize + tileSize);

  player = new Player();
  load(player);

  spawnBirds();

  wallOfDeath = new WallOfDeath(tilesHorizontal * tileSize + tileSize);
  load(wallOfDeath);

  CameraShaker.reset();
  camera = new Camera(player);

  world.updateWorldDepth();

  spawnOverworldStructures();
  spawnStarterChest();
}

void spawnOverworldStructures() {

  world.spawnStructure("Tree", new PVector(1, 6)); 

  int lastSpawnX = 0;
  final int MIN_DISTANCE = 4;

  for (int i = 0; i < tilesHorizontal - 13; i++) {

    if (i > lastSpawnX + MIN_DISTANCE) {

      if (random(1) < 0.35f) {
        lastSpawnX = i;
        world.spawnStructure("Tree", new PVector(i, 6));
      }
    }
  }

  world.spawnStructure("ButtonAltar", new PVector(40, 8));
}

void spawnBirds() {
  for (int i = 0; i < birdCount; i++) {
    Bird bird = new Bird();

    load(bird);
  }
}

void spawnStarterChest() {
  load(new Chest(69), new PVector(30 * tileSize, 10 * tileSize)); //69 is the forcedKey for an always pickaxe spawn
}

void draw() {

  if (!ResourceManager.isLoaded()) {
    handleLoading();

    return;
  }

  //wait until we are logged in
  if (dbUser == null) {
    handleLoggingInWaiting();

    return;
  }

  if (!hasCalledAfterResourceLoadSetup) {
    hasCalledAfterResourceLoadSetup = true;

    afterResouceLoadingSetup();
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

  if (Globals.currentGameState == Globals.GameState.InGame && player.position.y < (world.safeZone + 5) * tileSize) {
    ui.drawArrows();
  }

  popMatrix();
  //draw hud below popMatrix();

  handleGameFlow();

  ui.draw();
}

void updateObjects() {
  for (BaseObject object : destroyList) {

    //clean up light sources of they are destroyed
    if (lightSources.contains(object)) {
      lightSources.remove(object);
    }

    object.destroyed(); //handle some dying stuff, like removing ourselves from our type specific lists
  }
  destroyList.clear();

  for (BaseObject object : loadList) {
    object.specialAdd();
  }
  loadList.clear();

  for (BaseObject object : objectList) {
    object.update();
  }

  //used to start the game with the button
  if (startGame) {
    startGame = false;
    startAsteroidRain();
  }
}

void drawObjects() {
  for (BaseObject object : objectList) {
    object.draw();
  }
}

void handleGameFlow() {

  switch (Globals.currentGameState) {

  case MainMenu:

    //if we are in the main menu we start the game by pressing enter
    if (InputHelper.isKeyDown(Globals.STARTKEY)) {
      enterOverWorld(false);
    }

    break;

  case InGame:

    //Pauze the game
    if (InputHelper.isKeyDown(Globals.STARTKEY)) {
      Globals.currentGameState = Globals.GameState.GamePaused;
      InputHelper.onKeyReleased(Globals.STARTKEY);
    }

    break;

  case GameOver:
    Globals.gamePaused = true;

    //if we died we restart the game by pressing enter
    if (InputHelper.isKeyDown(Globals.STARTKEY)) { 
      enterOverWorld(true);
      InputHelper.onKeyReleased(Globals.STARTKEY);
    }

    break;

  case GamePaused:
    Globals.gamePaused = true;

    //if the game has been paused the player can contineu the game
    if (InputHelper.isKeyDown(Globals.STARTKEY)) {
      Globals.gamePaused = false;
      Globals.currentGameState = Globals.GameState.InGame;
      InputHelper.onKeyReleased(Globals.STARTKEY);
    }

    //Reset game to over world
    if (InputHelper.isKeyDown(Globals.BACKKEY)) {
      enterOverWorld(true);
    }

    break;
  }
}

//used to start a new game
void enterOverWorld(boolean reloadGame) {

  if (reloadGame) {
    setupGame();
  }

  Globals.gamePaused = false;
  Globals.currentGameState = Globals.GameState.Overworld;
  AudioManager.loopMusic("ForestAmbianceMusic");
}

void startGameSoon() {
  startGame = true;
}

void startAsteroidRain() {

  Globals.gamePaused = false;
  Globals.currentGameState = Globals.GameState.InGame;

  AudioManager.stopMusic("ForestAmbianceMusic");
  AudioManager.loopMusic("BackgroundMusic");

  ui.drawWarningOverlay = true;
  AudioManager.playSoundEffect("Siren");
}

void handleLoading() {
  background(0);

  String currentLoadingResource = ResourceManager.loadNext();

  float loadingBarWidth = float(ResourceManager.getCurrentLoadIndex()) / float(ResourceManager.getTotalResourcesToLoad());

  //loading bar
  fill(lerpColor(color(255, 0, 0), color(0, 255, 0), loadingBarWidth));
  rect(0, height - 40, loadingBarWidth * width, 40);

  if (currentLoadingResource != "") {
    //loading display
    fill(255);
    textSize(30);
    textAlign(CENTER);
    text("Loading: " + currentLoadingResource, width / 2, height - 10);
  }
}

void handleLoggingInWaiting() {
  background(0);

  fill(255);
  textSize(30);
  textAlign(CENTER);
  text("Logging in...", width / 2, height - 10);
}

BaseObject load(BaseObject newObject) { //handles all the basic stuff to add it to the processing stuff, so we can easily change it without copypasting a bunch
  loadList.add(newObject); //qeue for loading
  return newObject;
}

BaseObject load(BaseObject newObject, PVector setPosition) {
  loadList.add(newObject);
  newObject.moveTo(setPosition);
  return newObject;
}

BaseObject load(BaseObject newObject, boolean priority) { //load it RIGHT NOW. Only use in specially processed objects, like world
  if (priority) {
    newObject.specialAdd();
  } else {
    load(newObject);
  }
  return newObject;
}

void delete(BaseObject deletingObject) { //handles removal, call delete(object) to delete that object from the world
  destroyList.add(deletingObject); //queue for deletion
}

void setupLightSource(BaseObject object, float lightEmitAmount, float dimFactor) {
  object.lightEmitAmount = lightEmitAmount;
  object.distanceDimFactor = dimFactor;
  lightSources.add(object);
}

ArrayList<BaseObject> getObjectsInRadius(PVector pos, float radius) {
  ArrayList<BaseObject> objectsInRadius = new ArrayList<BaseObject>();

  for (BaseObject object : objectList) {

    if (object.suspended) {
      continue;
    }

    if (dist(pos.x, pos.y, object.position.x, object.position.y) < radius) {
      objectsInRadius.add(object);
    }
  }

  return objectsInRadius;
}

void keyPressed() {
  InputHelper.onKeyPressed(keyCode);
  InputHelper.onKeyPressed(key);

  // if(key == 'E' || key == 'e'){ // TEMPORARY (duh)
  //   load(new EnemyShocker(new PVector(1000, 500)));
  //   load(new EnemyGhost(new PVector(1100, 500)));
  // }
}

void keyReleased() {
  InputHelper.onKeyReleased(keyCode);
  InputHelper.onKeyReleased(key);
}
