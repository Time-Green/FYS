static class Globals{
  
  static boolean gamePaused = true;
  static GameState currentGameState = GameState.MainMenu;

  static enum GameState{
    MainMenu,
    ScoreMenu,
    OptionMenu,
    InGame,
    GameOver,
    GamePaused
  }
}
