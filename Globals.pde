static class Globals {

	//Controls
	//Movement
	static final int LEFTKEY = LEFT;
	static final int RIGHTKEY = RIGHT;
	static final int DIGKEY = DOWN;
	static final int JUMPKEY1 = UP;
	static final int JUMPKEY2 = 32; //Spacebar, why is SPACEBAR not a thing in prosessing?
	
	//inventory
	static final int INVENTORYKEY = ALT;
	static final int ITEMKEY = CONTROL;

	//Menus
	static final int STARTKEY = ENTER;
	static final int BACKKEY = BACKSPACE;

	//Ore values (later to be set in database?, yes)
	static final int COALVALUE = 50;
	static final int IRONVALUE = 100;
	static final int GREENICEVALUE = 300;
	static final int REDICEVALUE = 300;
  	static final int REDSTONEVALUE = 400;
	static final int GOLDVALUE = 500;
	static final int LAPISVALUE = 750;
	static final int DIAMONDVALUE = 1000;
  	static final int AMETHYSTVALUE = 2500;
	static final int EMERALDVALUE = 5000;
	
	//relicboost
	static final int HEALTH_BOOST = 10;
	static final float DAMAGE_BOOST = 0.01f;
	static final float REGEN_BOOST = 0.02f;
	static final float SPEED_BOOST = 0.01f;
	static final float LIGHT_BOOST = 10;

	//Achievements
	static final int LONEDIGGERACHIEVEMENT = 1;

	//world
	static final int OVERWORLD_HEIGHT = 10; // in grid tiles
	static final int TILES_HORIZONTAL = 50;
	static final float TILE_SIZE = 50; // in pixels

	//Gamestate
	static boolean gamePaused = true;
	static GameState currentGameState = GameState.MainMenu;

	static enum GameState {
		Overworld, // when the player can walk around but not mine
		MainMenu, // when main menu is showing
		ScoreMenu, // when the score is displayed, not used yet
		OptionMenu, // when the options menu is displayed, not used yet
		InGame, // when the world is getting blown up!
		GameOver, // when the player died
		GamePaused // when the player pauses the game
	}
}
