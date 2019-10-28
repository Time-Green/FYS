public class UIController {

  //Colors
  color titleColor = #FA3535;
  color titleOutline = #FAFA2A;
  color titleBackground = #FFA500;

  //Game HUD
  // Heart
  float heartWidth = 50;
  float heartHeight = 50;
  float heartX = 10;
  float heartY = 10;


  PImage heart;
  PFont font;
  float menuFontSize = 96;

  UIController() {
    font = ResourceManager.getFont("Menufont");
    heart = ResourceManager.getImage("Heart");
  }

  void draw() {
    if (Globals.currentGameState == Globals.gameState.menu) {
      startMenu();
    } else if (Globals.currentGameState == Globals.gameState.gameOver) {
      gameOver();
    } else if (Globals.currentGameState == Globals.gameState.inGame) {
      gameHUD();
    }

    rectMode(CORNER);
  }

  void gameOver() {
    rectMode(CENTER);
    fill(titleBackground);
    rect(width/2, (float)height/4.5, width-menuFontSize*4, menuFontSize*2);
    textAlign(CENTER);
    textFont(font, menuFontSize);
    fill(titleColor);
    text("Game", width/2, height/5);
    text("Over", width/2, height/3);
    textFont(font, menuFontSize/2.2);
    text("Press Enter to restart", width/2, height/2);
  }

  void startMenu() {

    rectMode(CENTER);
    fill(titleBackground);
    rect(width/2, (float)height/4.5, width-menuFontSize*4, menuFontSize*2);
    textAlign(CENTER);
    textFont(font, menuFontSize);
    fill(titleColor);
    text("ROCKY", width/2, height/5);
    text("RAIN", width/2, height/3);
    textFont(font, menuFontSize/2);
    text("Press Enter to start", width/2, height/2);
  }

  void gameHUD() {
    for (int i = 0; i < player.totalHealth; i++) {
      image(heart, heartX + i * heartWidth, heartY, heartWidth, heartHeight);
    }
  }
}
