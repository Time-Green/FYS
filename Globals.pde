static class Globals{
  
  //Controls
  //Movement
  static final int LEFTKEY = LEFT;
  static final int RIGHTKEY = RIGHT;
  static final int DIGKEY = DOWN;
  static final int JUMPKEY = 32; //Spacebar, why is SPACEBAR not a thing in prosessing?
  
  //inventory
  static final int INVENTORYKEY = ALT;
  static final int ITEMKEY = CONTROL;

  //Menus
  static final int STARTKEY = ENTER;
  static final int BACKKEY = BACKSPACE;

  //Gamestate
  static boolean gamePaused = true;
  static boolean isInOverWorld = true;  
  static GameState currentGameState = GameState.MainMenu;

  static enum GameState{
    OverWorld,
    MainMenu,
    ScoreMenu,
    OptionMenu,
    InGame,
    GameOver,
    GamePaused
  }
}
