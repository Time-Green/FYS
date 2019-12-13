ArrayList<BaseObject> objectList = new ArrayList<BaseObject>(); //<>//
ArrayList<BaseObject> destroyList = new ArrayList<BaseObject>(); //destroy and loadList are required, because it needs to be qeued before looping through the objectList,
ArrayList<BaseObject> loadList = new ArrayList<BaseObject>();    //otherwise we get a ConcurrentModificationException
ArrayList<BaseObject> reloadList = new ArrayList<BaseObject>();    //otherwise we get a ConcurrentModificationException

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
RunData runData;
ArrayList<PlayerRelicInventory> totalCollectedRelicShards;
ArrayList<LeaderboardRow> leaderBoard;
ArrayList<Achievement> playerAchievements; 
String loginStatus = "Logging in";

DisposeHandler dh;

World world;
Player player;
WallOfDeath wallOfDeath;
Camera camera;
UIController ui;
Enemy[] enemies;

boolean hasCalledAfterResourceLoadSetup = false;
boolean startGame = false; //start the game on next tick. needed to avoid concurrentmodificationexceptions

PGraphics leaderBoardGraphics;

void setup() {
  this.surface.setTitle("Rocky Rain");

  dh = new DisposeHandler(this);

  size(1280, 720, P2D);
  //fullScreen(P2D);

  databaseManager.beginLogin();
  
  AudioManager.setup(this);

  ResourceManager.setup(this);
  ResourceManager.prepareResourceLoading();

  CameraShaker.setup(this);

  ResourceManager.loadAll();

  //anti alliasing
  smooth(16);
}

void login() {
  databaseManager.login();
  loginStatus = "Getting player inventory";
  totalCollectedRelicShards = databaseManager.getPlayerRelicInventory();
  loginStatus = "Getting player achievements";
  playerAchievements = databaseManager.getPlayerAchievements();
  loginStatus = "Getting leaderboard";
  leaderBoard = databaseManager.getLeaderboard(10);
  loginStatus = "";
}

private void generateLeaderboardGraphics(){
  leaderBoardGraphics = createGraphics(int(Globals.TILE_SIZE * 9), int(Globals.TILE_SIZE * 5));

  leaderBoardGraphics.beginDraw();

  leaderBoardGraphics.textAlign(CENTER, CENTER);
  leaderBoardGraphics.textFont(ResourceManager.getFont("Block Stock"));
  leaderBoardGraphics.textSize(25);
  leaderBoardGraphics.text("Leaderboard", (Globals.TILE_SIZE * 9) / 2, 20);

  leaderBoardGraphics.textSize(12);

  int i = 0;

  for (LeaderboardRow leaderboardRow : leaderBoard) {

    if(i == 0){
      leaderBoardGraphics.fill(#C98910);
    }else if(i == 1){
      leaderBoardGraphics.fill(#A8A8A8);
    }else if(i == 2){
      leaderBoardGraphics.fill(#cd7f32);
    }else if(leaderboardRow.userName.equals(dbUser.userName)){
      leaderBoardGraphics.fill(255); // WIP
    }else{
      leaderBoardGraphics.fill(255);
    }
    
    leaderBoardGraphics.text("#" + (i + 1) + " " + leaderboardRow.userName + ": " + leaderboardRow.score + ", " + leaderboardRow.depth + "m", (Globals.TILE_SIZE * 9) / 2, 53 + i * 20);
    //println("#" + (i + 1) + " " + leaderboardRow.userName + ": " + leaderboardRow.score + ", " + leaderboardRow.depth + "m");
    i++;
  }

  leaderBoardGraphics.endDraw();
}

// gets called when all resources are loaded
void afterResouceLoadingSetup() {
  AudioManager.setMaxAudioVolume("Siren", 0.6f);
  AudioManager.setMaxAudioVolume("BackgroundMusic", 0.75f);
  AudioManager.setMaxAudioVolume("ForestAmbianceMusic", 0.7f);
  AudioManager.setMaxAudioVolume("DirtBreak", 0.5f);
  AudioManager.setMaxAudioVolume("HurtSound", 0.75f);

  for (int i = 1; i < 5; i++) {
    AudioManager.setMaxAudioVolume("Explosion" + i, 0.2f);
  }

  for (int i = 1; i < 5; i++) {
    AudioManager.setMaxAudioVolume("StoneBreak" + i, 0.5f);
  }

  for (int i = 1; i < 4; i++) {
    AudioManager.setMaxAudioVolume("GlassBreak" + i, 0.4f);
  }

  generateLeaderboardGraphics();

  //setup game and show title screen
  setupGame();
}

void setupGame() {
  player = null; //fixed world generation bug on restart
  objectList.clear();
  destroyList.clear();
  loadList.clear();
  tileList.clear();
  movableList.clear();
  mobList.clear();
  lightSources.clear();

  runData = new RunData();

  ui = new UIController();

  world = new World();

  player = new Player();
  load(player);

  wallOfDeath = new WallOfDeath();
  load(wallOfDeath);

  CameraShaker.reset();
  camera = new Camera(player);
}

void draw() {

  //wait until all resources are loaded and we are logged in
  if (!ResourceManager.isAllLoaded() || loginStatus != "") {
    handleLoadingScreen();

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
  world.draw();

  updateObjects();
  drawObjects();

  world.updateDepth();

  if (Globals.currentGameState == Globals.GameState.InGame && player.position.y < (Globals.OVERWORLD_HEIGHT + 5) * Globals.TILE_SIZE) {
    ui.drawArrows();
  }

  //image(leaderBoardGraphics, 12 * Globals.TILE_SIZE, 5 * Globals.TILE_SIZE);

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

  for (BaseObject object : reloadList) {
    tileList.remove((Tile)object);
    tileList.add((Tile)object);
  }
  reloadList.clear();

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

  AudioManager.loopMusic("ForestAmbianceMusic"); 
  Globals.gamePaused = false;
  Globals.currentGameState = Globals.GameState.Overworld;
  camera.lerpAmount = 0.075f;
}

void startGameSoon() {
  startGame = true;
}

void startAsteroidRain() {

  thread("startRegisterRunThread");

  Globals.gamePaused = false;
  Globals.currentGameState = Globals.GameState.InGame;

  AudioManager.stopMusic("ForestAmbianceMusic");
  AudioManager.loopMusic("BackgroundMusic");
  AudioManager.playSoundEffect("Siren");

  ui.drawWarningOverlay = true;
}

String dots = "";

void handleLoadingScreen(){
  background(0);

  float loadingBarWidth = ResourceManager.getLoadingAllProgress();

  //loading bar
  fill(lerpColor(color(255, 0, 0), color(0, 255, 0), loadingBarWidth));
  rect(0, height - 40, loadingBarWidth * width, 40);

  //loading display
  fill(255);
  textSize(30);
  textAlign(CENTER);

  if(loadingBarWidth < 1){
    text("Loading", width / 2, height - 10);
  }

  //login
  if(loginStatus != ""){
    //handleDots();
    text(loginStatus + dots, width / 2, height - 55);
  }else{
    fill(0, 255, 0);
    text("Logged in as " + dbUser.userName, width / 2, height - 55);
  }

  ArrayList<String> currentlyLoadingResources = ResourceManager.getLoadingResources();

  if(currentlyLoadingResources.size() == 0){
    return;
  }

  fill(255);
  textSize(25);
  textAlign(LEFT);
  text("Currently loading resources:", 10, 20);

  textSize(15);
  for (int i = 0; i < currentlyLoadingResources.size(); i++) {
    text(currentlyLoadingResources.get(i), 10, 40 + i * 18);
  }
}

private void handleDots(){

  if(frameCount % 20 == 0){
    dots += ".";
  }

  if(dots.length() > 3){
    dots = "";
  }
}

// start a thread to load 1 resource
void startLoaderThread(String currentResourceName, String currentResourceFileName){
  LoaderThread loaderThread = new LoaderThread(currentResourceName, currentResourceFileName);
  ResourceManager.loaderThreads.add(loaderThread);
  loaderThread.start();
}

// start a thread that registers a run start
void startRegisterRunThread(){
  databaseManager.registerRunStart();
}

// start a thread that registers a run end
void startRegisterEndThread(){
  databaseManager.registerRunEnd();
}

BaseObject load(BaseObject newObject) { //handles all the basic stuff to add it to the processing stuff, so we can easily change it without copypasting a bunch
  loadList.add(newObject); //qeue for loading
  return newObject;
}

BaseObject load(BaseObject newObject, PVector setPosition) {
  loadList.add(newObject);
  newObject.position.set(setPosition);
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

void reload(BaseObject reloadingObject) { //handles reload, call delete(object) to delete that object from the world
  reloadList.add(reloadingObject); //queue for reloading
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

  if(key == 'E' || key == 'e'){ // TEMPORARY (duh)
    load(new EnemyDigger(new PVector(1000, 500)));
  }
}

void keyReleased() {
  InputHelper.onKeyReleased(keyCode);
  InputHelper.onKeyReleased(key);
}
