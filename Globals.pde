static class Globals{
  
  static boolean gamePaused = true;
  static GameState currentGameState = GameState.MainMenu;

  static enum GameState{
    MainMenu,
    InGame,
    GameOver
  }
}
