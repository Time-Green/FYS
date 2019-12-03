public class UIController {

  //Colors
  private color titleColor = #FA3535;
  private color titleBackground = #FFA500;
  private color inventoryColor = #FBB65E;
  private color inventorySelectedColor = #56BACF;

  //Game HUD
  private float hudTextStartX = 90;

  //Achievement icon
  private float iconFrameSize = 25; 

  //Health
  private float healthBarHeight = 25; 
  private float healthBarWidth = 200; 

  private float barX = 10;
  private float barY = 10;
  
  private float slotOffsetY = 40; 
  private float slotSize = 60;
  private float slotOffsetX = slotSize * 1.5f;

  private final boolean DRAWSTATS = true;

  //Inventory
  private float inventorySize = 50;

  private PImage healthBarImage;

  //Text
  private PFont titleFont;
  private float titleFontSize = 96;

  private PFont instructionFont;
  private float instructionFontSize = titleFontSize / 2.2;

  private PFont hudFont;
  private float hudFontSize = 40;

  UIController(){
    titleFont = ResourceManager.getFont("Brickyol");
    instructionFont = ResourceManager.getFont("MenuFont");
    hudFont = ResourceManager.getFont("BrickBold");
    healthBarImage = ResourceManager.getImage("health-bar"); 
  }

  void draw() {

    //draw hud at center position
    rectMode(CENTER);
    textAlign(CENTER, CENTER);

    // draw hud based on current gamestate
    switch (Globals.currentGameState) {
      default :
        println("Something went wrong with the game state");
      break;
      case MainMenu:
        startMenu();
      break;	
      case GameOver:
        gameOver();
      break;
      case InGame :
        gameHUD();
      break;
      case GamePaused :
        pauseScreen();
      break;
      case OverWorld :
        //do nothing
      break;		
    }

    //reset rectMode
    rectMode(CORNER);
    textAlign(LEFT);

    if(DRAWSTATS){
      drawStats();
    }
  }

  void gameOver(){

    //background rect pos & size
    float rectXPos = width / 2;
    float rectYPos = (float)height / 4.15;
    float rectWidth = width - titleFontSize * 4;
    float rectHeight = titleFontSize * 2.5;

    //title
    fill(titleColor);
    textFont(titleFont);
    textSize(titleFontSize);
    text("Game Over", rectXPos, rectYPos, rectWidth, rectHeight);
    
    //sub text
    textFont(instructionFont);
    textSize(instructionFontSize);
    text("Space: restart", width / 2, height / 2 - 30);
  }

  void startMenu(){
    
    //background rect pos & size
    float rectXPos = width / 2;
    float rectYPos = (float)height / 4.15;
    float rectWidth = width - titleFontSize * 4;
    float rectHeight = titleFontSize * 2.5;

    //title background
    textFont(titleFont);
    fill(titleBackground);
    
    //rect(rectXPos, rectYPos, rectWidth, rectHeight);

    //title
    fill(titleColor);
    textFont(titleFont);
    textSize(titleFontSize);
    text("ROCKY RAIN", rectXPos, rectYPos, rectWidth, rectHeight);

    //sub text
    textFont(instructionFont);
    textSize(instructionFontSize);
    text("Press Space to start", width / 2, height / 2 - 30);
  }

  void gameHUD(){

    rectMode(CORNER); 
    fill(255, 0, 0);
    rect(barX, barY, healthBarWidth, healthBarHeight); 
    fill(0, 255, 0);
    rect(barX, barY, map(player.currentHealth, 0, 100, 0, 200), healthBarHeight);    
  
    textFont(hudFont);

    textAlign(LEFT);
    fill(255);
    textSize(hudFontSize);
    text("Score: " + player.score, 20, hudTextStartX);

    textAlign(LEFT);
    fill(255);
    textSize(hudFontSize);
    text("Depth: " + (player.getDepth() - 10), 20, hudTextStartX + hudFontSize); //-10 because we dont truly start at 0 depth, but at 10 depth

    drawInventory();
  }

  void drawStats(){
    textFont(hudFont);
    textAlign(RIGHT);
    fill(255);
    textSize(20);

    text(round(frameRate) + " FPS", width - 10, 140);
    text(objectList.size() + " objects", width - 10, 120);
    text(round(wallOfDeath.position.y) + " WoD Y Pos", width - 10, 100);
    text(round(player.position.x) + " Player X Pos", width - 10, 80);
    text(round(player.position.y) + " Player Y Pos", width - 10, 60);
    text(round((player.position.y - wallOfDeath.position.y)) + " Player/WoD Y Div", width - 10, 40);
    text("Logged in as " + dbUser.userName, width - 10, 20);
  }

  void pauseScreen(){
    //background rect pos & size
    float rectXPos = width / 2;
    float rectYPos = (float)height / 4.15;
    float rectWidth = width - titleFontSize * 4;
    float rectHeight = titleFontSize * 2.5;

    //title
    textFont(titleFont);
    fill(titleColor);
    textSize(titleFontSize);
    text("Paused", rectXPos, rectYPos, rectWidth, rectHeight);
    
    //sub text
    textFont(instructionFont);
    textSize(instructionFontSize);
    text("Space: continue", width / 2, height / 2 - 30);
    text("Backspace: restart", width / 2, height / 2 + 60);
  }

  // void achievementGet(){

  //   float maxTravelY = height - 20; 
  //   float frameY = height + 20; 

  //   while(frameY <= maxTravelY){
  //     fill(0); 
  //     rect(20, frameY, iconFrameSize, iconFrameSize);
  //     frameY += 1; 
  //   }
  // }

  void drawInventory(){
    
    for (int i = 0; i < player.maxInventory; i++) {
      if(i == player.selectedSlot - 1){
        fill(inventorySelectedColor);
      }
      else{
        fill(inventoryColor);
      }
      //Get the first position we can draw from, then keep going until we get the ast possible postion and work back from there
      rect(width * 0.95 - inventorySize * i, height * 0.9, inventorySize, inventorySize);
    }

    for(Item item : player.inventory){
      imageMode(CENTER);
      image(item.image, width * 0.95 - inventorySize * player.inventory.indexOf(item), height * 0.9, item.size.x, item.size.y);
      imageMode(CORNER);
    }
  }
}
