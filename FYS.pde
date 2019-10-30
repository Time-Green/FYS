ArrayList<Atom> atomList = new ArrayList<Atom>();

World world;
Player player;
Camera camera;
UIController ui;
Enemy[] enemies;

int tilesHorizontal = 50;
int tilesVertical = 50;
int tileWidth = 50;
int tileHeight = 50;

int backgroundColor = #87CEFA;

boolean firstTime = true;
boolean firstStart = true;

void setup(){
  size(1280, 720, P2D);

  ResourceManager.setup(this);
  prepareResourceLoading();

  CameraShaker.setup(this);
}

void setupGame(){
  atomList.clear();

  ui = new UIController();

  //ResourceManager.getSound("Background").loop();

  world = new World(tilesHorizontal * tileWidth + tileWidth);

  player = new Player();
  atomList.add(player);

  enemies = new Enemy[1];

  for (int i = 0; i < 1; ++i) {
    enemies[i] = new Enemy();
    atomList.add(enemies[i]);
  }

  WallOfDeath wallOfDeath = new WallOfDeath(tilesHorizontal * tileWidth + tileWidth);
  atomList.add(wallOfDeath);

  CameraShaker.reset();
  camera = new Camera(player);

  world.generateLayers(tilesVertical);

  if (firstTime) {
    Globals.gamePaused = true;
    Globals.currentGameState = Globals.gameState.menu;
  }
}

void draw(){

  if(!ResourceManager.isLoaded()){
    handleLoading();

    return;
  }

  //setup game after loading
  if(firstTime){
    setupGame();
    firstTime = false;
  }

  //push and pop are needed so the hud can be correctly drawn
  pushMatrix();

  CameraShaker.update();
  camera.update();

  world.update();
  world.draw(camera);

  for (Atom atom : atomList){
    atom.update(world);
    atom.draw();
  }

  world.updateDepth();

  if(keys[ENTER]){
    Globals.gamePaused = false;

    if(Globals.currentGameState == Globals.gameState.menu){
      Globals.currentGameState = Globals.gameState.inGame;
      if(firstStart){
        firstStart = false;
      }else{
        setupGame();
      }
    }else if(Globals.currentGameState == Globals.gameState.gameOver){
      Globals.currentGameState = Globals.gameState.inGame;
      setupGame();
    }
  }

  popMatrix();
  //draw hud below popMatrix();

  ui.draw();
}

void handleLoading(){
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

void prepareResourceLoading(){
  //Player
  ResourceManager.prepareLoad("player", "Sprites/player.jpg");
  //Enemies
  ResourceManager.prepareLoad("TestEnemy", "Sprites/eTest.jpg");
  //Tiles
  ResourceManager.prepareLoad("DestroyedBlock", "Sprites/Blocks/destroyed.png");
  ResourceManager.prepareLoad("GrassBlock", "Sprites/Blocks/grassblock.png");
  ResourceManager.prepareLoad("DirtBlock", "Sprites/Blocks/dirtblock.png");
  ResourceManager.prepareLoad("MossBlock", "Sprites/Blocks/mossblock.png");
  ResourceManager.prepareLoad("StoneBlock", "Sprites/Blocks/stoneblock.png");
  ResourceManager.prepareLoad("CoalBlock", "Sprites/Blocks/coal.block.jpg");
  ResourceManager.prepareLoad("IronBlock", "Sprites/Blocks/iron.block.jpg");
  ResourceManager.prepareLoad("GoldBlock", "Sprites/Blocks/gold.block.jpg");
  ResourceManager.prepareLoad("DiamondBlock", "Sprites/Blocks/diamond.block.jpg");
  ResourceManager.prepareLoad("BedrockBlock", "Sprites/Blocks/bedrock.block.jpg");
  //Day Night Ciycle
  for(int i = 0; i < 8; i++){
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
