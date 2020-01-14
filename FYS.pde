import java.util.*;
import java.lang.Character;

// List of everything we need to update
ArrayList<BaseObject> updateList = new ArrayList<BaseObject>(); 
ArrayList<BaseObject> destroyList = new ArrayList<BaseObject>(); // Destroy and loadList are required, because it needs to be qeued before looping through the updateList,
ArrayList<BaseObject> loadList = new ArrayList<BaseObject>(); // Otherwise we get a ConcurrentModificationException
ArrayList<BaseObject> reloadList = new ArrayList<BaseObject>(); // Otherwise we get a ConcurrentModificationException

//Drawing
ArrayList<ArrayList> drawList = new ArrayList<ArrayList>(); 
final int DRAWING_LAYERS = 10; // Increase if you add more layers
color backgroundColor = color(0);

// These only exists as helpers. All updating is handled from updateList
ArrayList<Tile> tileList = new ArrayList<Tile>();
ArrayList<Movable> movableList = new ArrayList<Movable>();
ArrayList<Mob> mobList = new ArrayList<Mob>();

// List of all objects that emit light
ArrayList<BaseObject> lightSources = new ArrayList<BaseObject>();

// Database variables
DatabaseManager databaseManager = new DatabaseManager();
AchievementHelper achievementHelper = new AchievementHelper(); 
LoginScreen loginScreen;
DbUser dbUser;
int loginStartTime;
RunData runData;
String loginStatus = "Logging in";
boolean isUploadingRunResults = false;
boolean userInLoginScreen;
boolean loadedPlayerInventory = false;
boolean loadedAllAchievements = false;
boolean loadedPlayerAchievements = false;
boolean loadedLeaderboard = false;
ArrayList<PlayerRelicInventory> totalCollectedRelicShards;
ArrayList<DbLeaderboardRow> leaderBoard;
ArrayList<Integer> unlockedAchievementIds; 
ArrayList<Achievement> allAchievements; 
ArrayList<AchievementRarity> allAchievementsRarity; 	
ArrayList<DatabaseVariable> databaseVariables;

// loading screen
final boolean SHOW_LOADING_RESOURCES = false;
final color TITLE_COLOR = #ffa259;
final float TITLE_FONT_SIZE = 120;
PFont titleFont;
PImage gameTitle;

//Database variables
ArrayList<DatabaseVariable> databaseVariable;
boolean loadedVariables = false;

//Scores
ArrayList<ScoreboardRow> scoreboard;
boolean loadedScores = false;

//Gamestate
boolean gamePaused = true;
GameState gameState = GameState.MainMenu;

// used to run code when closing the game
DisposeHandler disposeHandler;

// global game objects
World world;
Player player;
WallOfDeath wallOfDeath;
Camera camera;
UIController ui;
//Jukebox jukebox;

boolean hasCalledAfterResourceLoadSetup = false; // used to only call 'afterResouceLoadingSetup' function only once
boolean startGame = false; // start the game on next frame. needed to avoid concurrentmodificationexceptions

boolean parallaxEnabled = true;

// restart variables
float currentRestartTimer = 0;
final float MAX_RESTART_TIMER = 60; // 1.5 seconds

// setup the game
void setup()
{
	disposeHandler = new DisposeHandler(this);

	//size(1280, 720, P3D);
	fullScreen(P3D);

	TimeManager.setup(this, 1000f, 60f, true, true);

	surface.setResizable(true);
	surface.setTitle("Rocky Rain");

	checkUser();

  	AudioManager.setup(this);
	ResourceManager.setup(this);
	ResourceManager.loadAll(true);

	noStroke();
	preLoading();
}

// load resources that are needed in the loading screen
void preLoading()
{
	titleFont = createFont("Fonts/Block Stock.ttf", 32);
	gameTitle = loadImage("Sprites/GameTitle.png");
	textFont(titleFont);
}

// check if there is a local username we can use to log in
void checkUser()
{
	String[] userName = loadStrings("DbUser.txt");

	if(userName.length > 0)
	{
		databaseManager.beginLogin(userName[0]);
	}
	else
	{
		// if no name was found, show login screen
		loginScreen = new LoginScreen();
		userInLoginScreen = true;
	}
}

// used for initialisation that need loaded resources
void afterResouceLoadingSetup()
{
	setVolumes();
	
	prepareDrawingLayers();
	generateFlippedImages();

	//setup game and show title screen
	setupGame();
}

// set the audio volumes
void setVolumes()
{
	// sound effects
	AudioManager.setMaxVolume("Siren", 0.66f);
	AudioManager.setMaxVolume("HurtSound", 0.75f);
	AudioManager.setMaxVolume("LowHealth", 0.7f);

	for (int i = 1; i < 5; i++)
	{
		AudioManager.setMaxVolume("Explosion" + i, 0.728f);
	}
	
	//tile breaking
	AudioManager.setMaxVolume("DirtBreak", 0.7f);

	for (int i = 1; i < 5; i++)
	{
		AudioManager.setMaxVolume("StoneBreak" + i, 0.71f);
	}

	for (int i = 1; i < 4; i++)
	{
		AudioManager.setMaxVolume("GlassBreak" + i, 0.71f);
	}

	// music
	AudioManager.setMaxVolume("BackgroundMusic", 0.85f);
	AudioManager.setMaxVolume("ForestAmbianceMusic", 0.74f);

	for (int i = 1; i < JUKEBOX_SONG_AMOUNT; i++)
	{
		AudioManager.setMaxVolume("JukeboxMusic" + i, 0.8f);
	}
}

// pre generate flipped images for most common tiles
void generateFlippedImages()
{
	ResourceManager.generateFlippedImages("CoalBlock");
	ResourceManager.generateFlippedImages("IronBlock");
	ResourceManager.generateFlippedImages("DirtBlock");
	ResourceManager.generateFlippedImages("StoneBlock");
}

// reset the game
void setupGame()
{
	player = null; //fixed world generation bug on restart
	updateList.clear();
	destroyList.clear();
	loadList.clear();
	tileList.clear();
	movableList.clear();
	mobList.clear();
	lightSources.clear();

	cleanDrawingLayers();

	runData = new RunData();
	ui = new UIController();
	world = new World();
	player = new Player();
	wallOfDeath = new WallOfDeath();
	camera = new Camera(player);
	
	load(player);
	load(wallOfDeath);

	AudioManager.loopMusic("ForestAmbianceMusic");
	ui.initAchievementFrames();
	ui.currentLoadingScreenTransitionFill = 255;
}

// setup all drawing layers
void prepareDrawingLayers()
{
	drawList = new ArrayList<ArrayList>();

	for(int i = 0; i < DRAWING_LAYERS; i++)
	{
		drawList.add(new ArrayList<BaseObject>());
	}
}

// cleanup draw layers
void cleanDrawingLayers()
{
	for (ArrayList<BaseObject> drawLayer : drawList)
	{
		drawLayer.clear();
	}
}

// draw the game
void draw()
{
	if(userInLoginScreen)
	{
		loginScreen.update();
		loginScreen.draw();

		// when the filled in name is not empty, we close the login screen
		if(!loginScreen.enteredName.equals(""))
		{
			userFilledInName();
		}

		return;
	}

	//wait until all resources are loaded and we are logged in
	if (!ResourceManager.isAllLoaded() || !loadedPlayerInventory || !loadedAllAchievements || !loadedPlayerAchievements || !loadedLeaderboard)
	{
		handleLoadingScreen();

		return;
	}

	if (!hasCalledAfterResourceLoadSetup)
	{
		hasCalledAfterResourceLoadSetup = true;
		afterResouceLoadingSetup();
	}

	// based on dayNight image
	background(backgroundColor);

	//push and pop are needed so the hud can be correctly drawn
	pushMatrix();

	camera.update();

	world.draw();
	world.update();

	drawParallaxLayers();

	updateObjects();
	drawObjects();

	world.updateDepth();

	// needs to happan here because we are inside the push and pop matrix functions
	if (gameState == GameState.InGame && player.position.y < (OVERWORLD_HEIGHT + 5) * TILE_SIZE)
	{
		ui.drawArrows();
	}

	popMatrix();
	//draw hud below popMatrix();

	handleGameFlow();

	ui.draw();

	checkRestartGame();

	TimeManager.update();
}

// when r is hold, restart the game
void checkRestartGame()
{
	if(InputHelper.isKeyDown('r'))
	{
		currentRestartTimer += TimeManager.deltaFix;

		fill(255, 0, 0);
		textSize(60);
		textAlign(CENTER);
		text("RESTARTING GAME IN", width / 2, height / 2);
		text(nf(((MAX_RESTART_TIMER - currentRestartTimer) / 60f), 0, 2) + " sec", width / 2, height / 2 + 80);
	}
	else
	{
		currentRestartTimer = 0;
	}

	if(currentRestartTimer > MAX_RESTART_TIMER)
	{
		restartGame();
	}
}

// restart the game to allow another player to login
// best used with SAVE_USERNAME_AT_LOGIN set to false and with no name in dbUser.txt
void restartGame()
{
	currentRestartTimer = 0;

	loadedPlayerInventory = false;
	loadedAllAchievements = false;
	loadedPlayerAchievements = false;
	loadedLeaderboard = false;
	hasCalledAfterResourceLoadSetup = false;
	gamePaused = true;
	gameState = GameState.MainMenu;

	AudioManager.stopMusic("BackgroundMusic");

	checkUser();
}

// called then the player filled in there name in the login screen
void userFilledInName()
{
	// tell the game we dont need to show the login screen anymore
	userInLoginScreen = false;

	if(SAVE_USERNAME_AT_LOGIN)
	{
		// save username for next time the game starts
		String[] saveData = new String[1];
		
		saveData[0] = loginScreen.enteredName;
		saveStrings("DbUser.txt", saveData);
	}

	// begin login with filled in name
	databaseManager.beginLogin(loginScreen.enteredName);

	// clean up
	loginScreen = null;
}

// update all game objects
void updateObjects()
{
	for (BaseObject object : destroyList)
	{
		//clean up light sources of they are destroyed
		if (lightSources.contains(object))
		{
			lightSources.remove(object);
		}

		object.destroyed(); //handle some dying stuff, like removing ourselves from our type specific lists
	}

	destroyList.clear();

	for (BaseObject object : loadList)
	{
		object.specialAdd();
	}

	loadList.clear();

	for (BaseObject object : updateList)
	{
		object.update();
	}

	//used to start the game with the button
	if (startGame)
	{
		startGame = false;
		runData.timeToButtonPress = (millis() - world.worldAge) * 0.001; //* 0.001 to get the time in seconds
		startAsteroidRain();
	}
}

// draw all game objects
void drawObjects()
{
	for(ArrayList<BaseObject> drawUs : drawList)
	{
		for(BaseObject object : drawUs)
		{
			object.draw();
		}
	}
}

// draw the parallax layers
void drawParallaxLayers()
{
	for(int i = world.parallaxMap.size() - 1; i >= 0; i--)
	{
		ArrayList<ArrayList<ParallaxTile>> parallaxList = world.parallaxMap.get(i);

		for(ArrayList<ParallaxTile> yList : parallaxList)
		{
			for(ParallaxTile tile : yList)
			{
				tile.draw();
			}
		}
	}
}

// handle the flow of the game
void handleGameFlow()
{
  switch (gameState)
  {
	case MainMenu:
		//if we are in the main menu we start the game by pressing enter
		if (InputHelper.isKeyDown(START_KEY))
		{
			enterOverWorld(false);
		}

		break;

	case InGame:
		//Pauze the game
		if (InputHelper.isKeyDown(START_KEY))
		{
			gameState = GameState.GamePaused;
			InputHelper.onKeyReleased(START_KEY);
		}

		break; 

	case Overworld:
		gamePaused = false; 

		if(InputHelper.isKeyDown(ACHIEVEMENT_SCREEN_KEY))
		{
			gameState = GameState.AchievementScreen; 
			ui.drawAchievementScreen();
			InputHelper.onKeyReleased(ACHIEVEMENT_SCREEN_KEY);
		}

		break; 

	case GameOver:
		gamePaused = true;

		//if we died and we uploaded the run stats, we restart the game by pressing enter
		if (InputHelper.isKeyDown(START_KEY) && !isUploadingRunResults)
		{
			enterOverWorld(true);
			InputHelper.onKeyReleased(START_KEY);
		}

		break;

	case AchievementScreen:
		gamePaused = true; 

		if(InputHelper.isKeyDown(START_KEY))
		{
			gameState = GameState.Overworld; 
			InputHelper.onKeyReleased(START_KEY);
		}

		break; 

	case GamePaused:
		gamePaused = true;

		//if the game has been paused the player can continue the game
		if (InputHelper.isKeyDown(START_KEY))
		{
			gamePaused = false;
			gameState = GameState.InGame;
			InputHelper.onKeyReleased(START_KEY);
		}

		//Reset game to over world
		if (InputHelper.isKeyDown(BACK_KEY))
		{
			AudioManager.stopMusic("BackgroundMusic");
			enterOverWorld(true);
		}

		break;
	}
}

//used to start a new game
void enterOverWorld(boolean reloadGame)
{
	if (reloadGame)
	{
		setupGame();
	}

	gamePaused = false;
	gameState = GameState.Overworld;
	camera.lerpAmount = 0.075f;
}

// start the game the next frame
void startGameSoon()
{
  	startGame = true;
}

//called when the player pressed the button
void startAsteroidRain()
{
	thread("startRegisterRunThread");

	gamePaused = false;
	gameState = GameState.InGame;

	AudioManager.stopMusic("ForestAmbianceMusic");
	AudioManager.loopMusic("BackgroundMusic");
	AudioManager.playSoundEffect("Siren");

	ui.drawWarningOverlay = true;
	//jukebox.stopMusicOverTime(1500);
}

//is called when the played died
void endRun()
{
	isUploadingRunResults = true;
	gamePaused = true;
	gameState = GameState.GameOver;
	ui.drawWarningOverlay = false;
	AudioManager.stopMusic("BackgroundMusic");

	thread("startRegisterEndThread");
}

// show the loading screen
void handleLoadingScreen()
{
	background(0);

	textFont(titleFont);

	float loadingBarWidth = ResourceManager.getLoadingAllProgress();

	//loading bar
	fill(lerpColor(color(255, 0, 0), color(0, 255, 0), loadingBarWidth));
	rect(0, height - 40, loadingBarWidth * width, 40);

	//loading display
	fill(255);
	textSize(30);
	textAlign(CENTER);

	if(loadingBarWidth < 1)
	{
		text("Loading", width / 2, height - 5);
	}

	//login
	if(loginStatus != "Logged in")
	{
		text(loginStatus, width / 2, height - 50);
	}
	else
	{
		fill(0, 255, 0);
		text("Logged in as " + dbUser.userName, width / 2, height - 50);
	}

	if(SHOW_LOADING_RESOURCES)
	{
		ArrayList<String> currentlyLoadingResources = ResourceManager.getLoadingResources();

		if(currentlyLoadingResources.size() == 0)
		{
			return;
		}

		fill(255);
		textSize(25);
		textAlign(LEFT);
		text("Currently loading resources:", 10, 20);

		textSize(15);

		int xPosMultiplier = -1;
		int yPosMultiplier = 0;

		for (int i = 0; i < currentlyLoadingResources.size(); i++)
		{
			if(i % 33 == 0)
			{
				xPosMultiplier++;
				yPosMultiplier = 0;
			}

			text(currentlyLoadingResources.get(i), 10 + (150 * xPosMultiplier), 40 + yPosMultiplier * 18);

			yPosMultiplier++;
		}
	}

	drawTitleImage();
}

// because we don't have a UiManager instance when loading, the title rendering needs to happan separately here
void drawTitleImage()
{
	imageMode(CENTER);
	image(gameTitle, width / 2, height / 4.5f, width * 0.8f, height * 0.3f);
	imageMode(CORNER);
}

// handles all the basic stuff to add it to the processing stuff, so we can easily change it without copypasting a bunch
BaseObject load(BaseObject newObject)
{
	loadList.add(newObject); //qeue for loading

	return newObject;
}

// load a new object and set its position
BaseObject load(BaseObject newObject, PVector setPosition)
{
	loadList.add(newObject);
	newObject.position.set(setPosition);

	return newObject;
}

// load it RIGHT NOW. Only use in specially processed objects, like world
BaseObject load(BaseObject newObject, boolean priority)
{
	if (priority)
	{
		newObject.specialAdd();
	}
	else
	{
		load(newObject);
	}

	return newObject;
}

// handles removal, call delete(object) to delete that object from the world
void delete(BaseObject deletingObject)
{
	destroyList.add(deletingObject); //queue for deletion
  	deletingObject.onDeleteQueued(); //if it has childs it has to delete, it cant do so in the delete tick so do it now
}

// handles reload, call delete(object) to delete that object from the world
void reload(BaseObject reloadingObject)
{
	reloadList.add(reloadingObject); //queue for reloading
}

// add a new light source
void setupLightSource(BaseObject object, float lightEmitAmount, float dimFactor)
{
	object.lightEmitAmount = lightEmitAmount;
	object.distanceDimFactor = dimFactor;
	lightSources.add(object);
}

// get all objects inside a radius
ArrayList<BaseObject> getObjectsInRadius(PVector pos, float radius)
{
	ArrayList<BaseObject> objectsInRadius = new ArrayList<BaseObject>();

	try
	{
		for (BaseObject object : updateList)
		{
			if (object.suspended)
			{
				continue;
			}

			if (dist(pos.x, pos.y, object.position.x, object.position.y) < radius)
			{
				objectsInRadius.add(object);
			}
		}
	}
	catch (Exception e)
	{
		// sometimes we get concurrent modification exception, in that case we just try again
		return getObjectsInRadius(pos, radius);
	}

	return objectsInRadius;
}

// seconds to vsync framerate
int timeInSeconds(int seconds)
{
	return seconds *= 60;
}

// seconds to vsync framerate
float timeInSeconds(float seconds)
{
	return seconds *= 60;
}

// processing key pressed event
void keyPressed()
{
	InputHelper.onKeyPressed(keyCode);
	InputHelper.onKeyPressed(key);

	//Debug code
	//debugInput();
}

// processing key released event
void keyReleased()
{
	InputHelper.onKeyReleased(keyCode);
	InputHelper.onKeyReleased(key);
}

// used to get input for debugging
void debugInput()
{
	// Test spawns
	if(key == 'E' || key == 'e')
	{
		load(new EnemyMimic(new PVector(1000,400)));
	}

	if(key == 'Q' || key == 'q')
	{
		load(new ScorePickup(50,ResourceManager.getImage("CoalPickup")));
	}

	if (key == 'T' || key == 't')
	{
		load(new MagnetPickup());
	}

	// if (key == 'Y' || key == 'y')
	// {
	// 	//Doesn't work right now
	// 	databaseManager.deleteVariable("poop");
	// }

	if (key == 'U' || key == 'u')
	{
		// databaseManager.getAllPickupScores();
		// ui.generateScoreboardGraphic();
	}

	if(key == 'p')
	{
		parallaxEnabled = !parallaxEnabled;
	}
}

