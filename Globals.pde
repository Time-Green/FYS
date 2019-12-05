static class Globals{
  
  //Controls
  //Movement
  static final int LEFTKEY = LEFT;
  static final int RIGHTKEY = RIGHT;
  static final int DIGKEY = DOWN;
  static final int JUMPKEY1 = 32; //Spacebar, why is SPACEBAR not a thing in prosessing?
  static final int JUMPKEY2 = UP;
  
  //inventory
  static final int INVENTORYKEY = ALT;
  static final int ITEMKEY = CONTROL;

  //Menus
  static final int STARTKEY = ENTER;
  static final int BACKKEY = BACKSPACE;

  //Gamestate
  static boolean gamePaused = true;
  static GameState currentGameState = GameState.MainMenu;

  static enum GameState{
    Overworld, // when the player can walk around but not mine
    MainMenu, // when main menu is showing
    ScoreMenu, // when the score is displayed, not used yet
    OptionMenu, // when the options menu is displayed, not used yet
    InGame, // when the world is getting blown up!
    GameOver, // when the player died
    GamePaused // when the player pauses the game
  }
}
