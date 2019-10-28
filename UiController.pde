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
    textAlign(CENTER);

    if(Globals.currentGameState == Globals.gameState.menu){
      startMenu();
    }else if(Globals.currentGameState == Globals.gameState.gameOver){
      gameOver();
    }else if(Globals.currentGameState == Globals.gameState.inGame){
      gameHUD();
    }

    //reset rectMode
    rectMode(CORNER);
    textAlign(LEFT);

    drawFps();
  }

  void gameOver(){
    fill(titleBackground);
    rect(width / 2, (float)height / 4.15, width - menuFontSize * 4, menuFontSize * 2.5);

    fill(titleColor);
    textSize(menuFontSize);
    text("Game\nOver", width / 2, height / 5);
    
    textSize(menuFontSize / 2.2);
    text("Press Enter to restart", width / 2, height / 2);
  }

  void startMenu(){
    fill(titleBackground);
    rect(width / 2, (float)height / 4.15, width - menuFontSize * 4, menuFontSize * 2.5);

    fill(titleColor);
    textSize(menuFontSize);
    text("ROCKY\nRAIN", width / 2, height / 5);

    textSize(menuFontSize / 2);
    text("Press Enter to start", width / 2, height / 2);
  }

  void gameHUD(){
    for (int i = 0; i < player.currentHealth; i++) {
      image(heart, heartX + i * heartWidth, heartY, heartWidth, heartHeight);
    }

    textAlign(LEFT);
    fill(255);
    textSize(20);
    text("Score:" + player.score, 20, 80);
  }

  void drawFps(){
    textAlign(LEFT);
    fill(255);
    textSize(20);
    text(round(frameRate) + " FPS", width - 150, 25);
  }
}
