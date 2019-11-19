public class UIController {

  //Colors
  color titleColor = #FA3535;
  color titleBackground = #FFA500;

  //Game HUD
  //Heart
  float heartWidth = 50;
  float heartHeight = 50;
  float heartX = 10;
  float heartY = 10;
  float slotOffsetX = 40; 
  float slotOffsetY = 40; 
  float slotSize = 40; 

  PImage heart;
  PFont font;
  float menuFontSize = 96;

  UIController(){
    font = ResourceManager.getFont("Menufont");
    heart = ResourceManager.getImage("Heart");

    textFont(font);
  }

  void draw(){

    if(InputHelper.isKeyDown('p') && Globals.currentGameState == Globals.GameState.InGame){
      Globals.gamePaused = true;
      Globals.currentGameState = Globals.GameState.GamePaused;
    }

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

    drawStats();
  }

  void gameOver(){

    //background rect pos & size
    float rectXPos = width / 2;
    float rectYPos = (float)height / 4.15;
    float rectWidth = width - menuFontSize * 4;
    float rectHeight = menuFontSize * 2.5;

    //title background
    fill(titleBackground);
    rect(rectXPos, rectYPos, rectWidth, rectHeight);

    //title
    fill(titleColor);
    textSize(menuFontSize);
    text("Game Over", rectXPos, rectYPos, rectWidth, rectHeight);
    
    //sub text
    textSize(menuFontSize / 2.2);
    text("Press Enter to restart", width / 2, height / 2 - 30);
  }

  void startMenu(){
    
    //background rect pos & size
    float rectXPos = width / 2;
    float rectYPos = (float)height / 4.15;
    float rectWidth = width - menuFontSize * 4;
    float rectHeight = menuFontSize * 2.5;

    //title background
    fill(titleBackground);
    rect(rectXPos, rectYPos, rectWidth, rectHeight);

    //title
    fill(titleColor);
    textSize(menuFontSize);
    text("ROCKY RAIN", rectXPos, rectYPos, rectWidth, rectHeight);

    //sub text
    textSize(menuFontSize / 2);
    text("Press Enter to start", width / 2, height / 2 - 30);
  }

  void gameHUD(){
    for (int i = 0; i < player.currentHealth; i++) {
      image(heart, heartX + i * heartWidth, heartY, heartWidth, heartHeight);
    }

    textAlign(LEFT);
    fill(255);
    textSize(20);
    text("Score:" + player.score, 20, 80);

    textAlign(LEFT);
    fill(255);
    textSize(20);
    text("Depth:" + round((player.getDepth() / tileHeight) - 10), 20, 100);

    fill(0); 
    rect(width - slotOffsetX, height - slotOffsetY, slotSize, slotSize); 
  }

  void drawStats(){
    textAlign(RIGHT);
    fill(255);
    textSize(20);
    text(round(frameRate) + " FPS", width - 10, 25);
    text(objectList.size() + " objects", width - 10, 45);
  }

  void pauseScreen(){
    //background rect pos & size
    float rectXPos = width / 2;
    float rectYPos = (float)height / 4.15;
    float rectWidth = width - menuFontSize * 4;
    float rectHeight = menuFontSize * 2.5;

    //title background
    fill(titleBackground);
    rect(rectXPos, rectYPos, rectWidth, rectHeight);

    //title
    fill(titleColor);
    textSize(menuFontSize);
    text("Paused", rectXPos, rectYPos, rectWidth, rectHeight);
    
    //sub text
    textSize(menuFontSize / 2.2);
    text("Press Enter to continue", width / 2, height / 2 - 30);
    text("Press CTRL to restart", width / 2, height / 2 + 60);
  }
}
