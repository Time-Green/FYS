public class UIController {

  //Colors
  private color titleColor = #FA3535;
  private color titleBackground = #FFA500;
  private color inventoryColor = #FBB65E;

  //Game HUD
  private float hudTextStartX = 90;

  //Heart
  private float heartWidth = 50;
  private float heartHeight = 50;
  private float heartX = 10;
  private float heartY = 10;
  
  private float slotOffsetY = 40; 
  private float slotSize = 60;
  private float slotOffsetX = slotSize * 1.5f;

  private final boolean DRAWSTATS = true;

  //Inventory
  private final float INTENTORYSIZE = 50;
  private float inventoryX = width * .8;
  private float inventoryY = INTENTORYSIZE;
  
  private final int INVENTORYSLOTS = 3;

  private PImage heart;

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
    heart = ResourceManager.getImage("Heart");
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
    }

    //reset rectMode
    rectMode(CORNER);
    textAlign(LEFT);

    // drawInventory();

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

    

    //title background
    fill(titleBackground);
    rect(rectXPos, rectYPos, rectWidth, rectHeight);

    //title
    fill(titleColor);
    textSize(titleFontSize);
    text("Game Over", rectXPos, rectYPos, rectWidth, rectHeight);
    
    //sub text
    textFont(instructionFont);
    textSize(instructionFontSize);
    text("Press Enter to restart", width / 2, height / 2 - 30);
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
    textSize(titleFontSize);
    text("ROCKY RAIN", rectXPos, rectYPos, rectWidth, rectHeight);

    //sub text
    textFont(instructionFont);
    textSize(instructionFontSize);
    text("Press Enter to start", width / 2, height / 2 - 30);
  }

  void gameHUD(){
    for (int i = 0; i < player.currentHealth; i++) {
      image(heart, heartX + i * heartWidth, heartY, heartWidth, heartHeight);
    }

    textFont(hudFont);

    textAlign(LEFT);
    fill(255);
    textSize(hudFontSize);
    text("Score: " + player.score, 20, hudTextStartX);

    textAlign(LEFT);
    fill(255);
    textSize(hudFontSize);
    text("Depth: " + round((player.getDepth() / tileHeight) - 10), 20, hudTextStartX + hudFontSize);

    //Inventory
    fill(inventoryColor);
    for (int i = 0; i < INVENTORYSLOTS; i++) {
      //Get the first position we can draw from, then keep going until we get the ast possible postion and work back from there
      rect((width - slotSize) - ((slotSize*INVENTORYSLOTS)-(slotOffsetX*i)) , inventoryY, slotSize, slotSize);
    }
    
  }

  void drawStats(){
    textAlign(RIGHT);
    fill(255);
    textSize(20);
    text(round(frameRate) + " FPS", width - 10, height - 120);
    text(objectList.size() + " objects", width - 10, height - 100);
    text(round(wallOfDeath.position.y) + " WoD Y Pos", width - 10, height - 80);
    text(round(player.position.x) + " Player X Pos", width - 10, height - 60);
    text(round(player.position.y) + " Player Y Pos", width - 10, height - 40);
    text(round((player.position.y - wallOfDeath.position.y)) + " Player/WoD Y Div", width - 10, height - 20);
  }

  void pauseScreen(){
    //background rect pos & size
    float rectXPos = width / 2;
    float rectYPos = (float)height / 4.15;
    float rectWidth = width - titleFontSize * 4;
    float rectHeight = titleFontSize * 2.5;

    //title background
    textFont(titleFont);
    fill(titleBackground);
    rect(rectXPos, rectYPos, rectWidth, rectHeight);

    //title
    fill(titleColor);
    textSize(titleFontSize);
    text("Paused", rectXPos, rectYPos, rectWidth, rectHeight);
    
    //sub text
    textSize(instructionFontSize);
    text("Press Enter to continue", width / 2, height / 2 - 30);
    text("Press CTRL to restart", width / 2, height / 2 + 60);
  }

  // void drawInventory(){
  //   for(Item item : player.inventory){
  //     image(item.image, inventoryX + INTENTORYSIZE * player.inventory.indexOf(item), inventoryY, item.size.x, item.size.y);
  //   }
  // }
}
