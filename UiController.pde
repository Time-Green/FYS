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

  PImage heart;
  PFont font;
  float menuFontSize = 96;

  UIController(){
    font = ResourceManager.getFont("Menufont");
    heart = ResourceManager.getImage("Heart");

    textFont(font);
  }

  void draw(){
    //draw hud at center position
    rectMode(CENTER);
    textAlign(CENTER, CENTER);

    // draw hud based on current gamestate
    if(Globals.currentGameState == Globals.GameState.MainMenu){
      startMenu();
    }else if(Globals.currentGameState == Globals.GameState.GameOver){
      gameOver();
    }else if(Globals.currentGameState == Globals.GameState.InGame){
      gameHUD();
    }

    //reset rectMode
    rectMode(CORNER);
    textAlign(LEFT);

    drawFps();
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
  }

  void drawFps(){
    textAlign(RIGHT);
    fill(255);
    textSize(20);
    text(round(frameRate) + " FPS", width - 10, 25);
  }
}
