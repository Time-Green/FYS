//Controls
//Movement
final int LEFT_KEY = LEFT;
final int RIGHT_KEY = RIGHT;
final int DIG_KEY = DOWN;
final int JUMP_KEY_1 = UP;
final int JUMP_KEY_2 = 32; // spacebar

//inventory
final int INVENTORY_KEY_A = CONTROL;
final int INVENTORY_KEY_B = ALT;

//Menus
final int START_KEY = ENTER;
final int BACK_KEY = BACKSPACE;
final int ACHIEVEMENT_SCREEN_KEY = 32; 

//Audio volume
float musicVolume = 0.0f;
float soundEffectVolume = 0.0f;

//Ore values (later to be set in database?, yes)
// final int COAL_VALUE = databaseManager.getIntValue("CoalPickupValue");
// final int IRON_VALUE = databaseManager.getIntValue("IronPickupValue");
// final int GREEN_ICE_VALUE = databaseManager.getIntValue("EmeraldPickupValue");
// final int RED_ICE_VALUE = databaseManager.getIntValue("RubyPickupValue");
// final int BLUE_ICE_VALUE = databaseManager.getIntValue("SaphirePickupValue");
// final int REDSTONE_VALUE = databaseManager.getIntValue("RedstonePickupValue");
// final int GOLD_VALUE = databaseManager.getIntValue("GoldPickupValue");
// final int LAPIS_VALUE = databaseManager.getIntValue("LapisPickupValue");
// final int DIAMOND_VALUE = databaseManager.getIntValue("DiamondPickupValue");
// final int AMETHYST_VALUE = databaseManager.getIntValue("AmethystPickupValue");
// final int METEORITE_VALUE = databaseManager.getIntValue("MeteoritePickupValue");

final int COAL_VALUE = 50;
final int IRON_VALUE = 100;
final int GREEN_ICE_VALUE = 250;
final int RED_ICE_VALUE = 300;
final int BLUE_ICE_VALUE = 350;
final int REDSTONE_VALUE = 400;
final int GOLD_VALUE = 500;
final int LAPIS_VALUE = 750;
final int DIAMOND_VALUE = 1000;
final int AMETHYST_VALUE = 2000;
final int METEORITE_VALUE = 5000;

//Dig bonuses
final int BONUSDEPTH = 50;

//relicboost
final int HEALTH_BOOST = 10;
final float DAMAGE_BOOST = 0.01f;
final float REGEN_BOOST = 0.02f;
final float SPEED_BOOST = 0.01f;
final float LIGHT_BOOST = 10;

//Achievements
final int LONE_DIGGER_ACHIEVEMENT = 0;

//world
final int OVERWORLD_HEIGHT = 10; // in grid tiles
final int TILES_HORIZONTAL = 50;
final float TILE_SIZE = 50; // in pixels

//Directions
final int NORTH = 0;
final int SOUTH = 1;
final int EAST = 2;
final int WEST = 3;
final int NORTHEAST = 4;
final int SOUTHEAST = 5;
final int NORTHWEST = 6;
final int SOUTHWEST = 7;
final int DIRECTIONS = 8;

//drawing layers
final int BACKGROUND_LAYER = 0;
final int BACKWALL_LAYER = 1;
final int OBJECT_LAYER = 2;
final int MOB_LAYER = 3;
final int PLAYER_LAYER = 4;
final int TILE_LAYER = 5;
final int PRIORITY_LAYER = 6;

//Smoothing
final boolean PARALLAX_ENABLED = true;
final float PARALLAX_INTENSITY = 0.05;
final float PARALLAX_NOISE_SCALE = 0.1; //the parallax background has one constant noise generator, so we dont get the ugly transitions from noise like normal biomes
final float PARALLAX_NOISE_POSSIBILITY = 0.46f;

//login
final int MAX_LOGIN_NAME_SIZE = 20;

//Gamestate
boolean gamePaused = true;
GameState currentGameState = GameState.MainMenu;

//Movement
final float SPEED_LIMIT = TILE_SIZE; //otherwise we can phase through tiles like the flash, because we only check the closest tiles and not the ones BEHIND them
final float GRAVITY_LIMIT = 20;

enum GameState
{
	Overworld, // when the player can walk around but not mine
	MainMenu, // when main menu is showing
	ScoreMenu, // when the score is displayed, not used yet
	OptionMenu,
	AchievementScreen,
	InGame, // when the world is getting blown up!
	GameOver, // when the player died
	GamePaused // when the player pauses the game
}