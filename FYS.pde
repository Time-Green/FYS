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

void setupGame(boolean firstTime){
  atomList.clear();
  
  ui = new UIController();
  
  ResourceManager.getSound("Background").loop();

  world = new World();

  player = new Player();
  atomList.add(player);

  WallOfDeath wallOfDeath = new WallOfDeath(tilesHorizontal * tileWidth + tileWidth);
  atomList.add(wallOfDeath);

  camera = new Camera(player);

  world.generateLayers(tilesVertical);
  if(firstTime){
    Globals.gamePaused = true;
    Globals.currentGameState = Globals.gameState.menu;
  }
}

void setup(){
  size(1280, 720, P2D);

  ResourceManager.setup(this);
  loadResources();
  setupGame(true);

}

void draw(){
  background(backgroundColor);
  
  //push and pop are needed so the hud can be correctly drawn
  pushMatrix();

  camera.update();

  world.update();
  world.draw(camera);

  for(Atom atom : atomList){
    atom.update(world);
    atom.draw();
  }

  world.updateDepth();

  if(keys[ENTER]){
    Globals.gamePaused = false;

    if(Globals.currentGameState == Globals.gameState.menu){
      Globals.currentGameState = Globals.gameState.inGame;
      setupGame(false);
    }
  }
  
  popMatrix();
  //draw hud below popMatrix();

  ui.draw();
}

void loadResources(){
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
