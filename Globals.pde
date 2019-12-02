static class Globals{
  
  //Controls
  static final int LEFTKEY = LEFT;
  static final int RIGHTKEY = RIGHT;
  static final int DIGKEY = DOWN;
  static final int JUMPKEY = 32; //Spacebar, why is SPACEBAR not a thing in prosessing?
  
  //static final int INVENTORYKEY = DOWN;
  //static final int ITEMKEY = DOWN;
  
  static final int CONFIRMKEY = JUMPKEY;
  static final int ENTERKEY = ENTER;
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
