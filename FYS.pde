import java.util.*;

// List of everything we need to update
ArrayList<BaseObject> updateList = new ArrayList<BaseObject>(); 

ArrayList<BaseObject> destroyList = new ArrayList<BaseObject>(); //destroy and loadList are required, because it needs to be qeued before looping through the updateList,
ArrayList<BaseObject> loadList = new ArrayList<BaseObject>();    //otherwise we get a ConcurrentModificationException
ArrayList<BaseObject> reloadList = new ArrayList<BaseObject>();    //otherwise we get a ConcurrentModificationException

//Drawing
ArrayList<ArrayList> drawList = new ArrayList<ArrayList>(); 
int drawingLayers = 10; //increase if you add more layers

// These only exists as helpers. All updating is handled from updateList
ArrayList<Tile> tileList = new ArrayList<Tile>();
ArrayList<Movable> movableList = new ArrayList<Movable>();
ArrayList<Mob> mobList = new ArrayList<Mob>();

// list of all objects that emit light
ArrayList<BaseObject> lightSources = new ArrayList<BaseObject>();

// database variables
//this is a mess, we need to orginaze more in groups
LoginScreen loginScreen;
boolean userInLoginScreen;
boolean loadedPlayerInventory = false;
boolean loadedAllAchievements = false;
boolean loadedPlayerAchievements = false;
boolean loadedLeaderboard = false;
AchievementHelper achievementHelper = new AchievementHelper(); 
DatabaseManager databaseManager = new DatabaseManager();
DbUser dbUser;
int loginStartTime;
RunData runData;
ArrayList<PlayerRelicInventory> totalCollectedRelicShards;
ArrayList<DbLeaderboardRow> leaderBoard;
ArrayList<Integer> unlockedAchievementIds; 
ArrayList<Achievement> allAchievements; 
ArrayList<Integer> vars;
String loginStatus = "Logging in";
boolean isUploadingRunResults = false;

//Scores
ArrayList<ScoreboardRow> scoreboard;
boolean loadedScores = false;

// used to run code on closing game
DisposeHandler disposeHandler;

// global game objects
World world;
Player player;
WallOfDeath wallOfDeath;
Camera camera;
UIController ui;

boolean hasCalledAfterResourceLoadSetup = false; // used to only call 'afterResouceLoadingSetup' function only once
boolean startGame = false; // start the game on next frame. needed to avoid concurrentmodificationexceptions

void setup()
{
	disposeHandler = new DisposeHandler(this);

	size(1280, 720, P2D);

	//fullScreen(P2D);

	surface.setResizable(true);
	surface.setTitle("Rocky Rain");

	checkUser();

  	AudioManager.setup(this);
	ResourceManager.setup(this);
	ResourceManager.prepareResourceLoading();
	ResourceManager.loadAll();
}

void checkUser()
{
	String[] userName = loadStrings("DbUser.txt");

	if(userName.length > 0)
	{
		databaseManager.beginLogin(userName[0]);
	}
	else if(userName.length == 0)
	{
		// if no name was filled in, show login screen
		loginScreen = new LoginScreen();
		userInLoginScreen = true;
	}
}

// used for initialisation that need loaded resources
void afterResouceLoadingSetup()
{
	AudioManager.setMaxVolume("Siren", 0.55f * musicVolume);
	AudioManager.setMaxVolume("BackgroundMusic", 0.7f * musicVolume);
	AudioManager.setMaxVolume("ForestAmbianceMusic", 0.7f * musicVolume);
	AudioManager.setMaxVolume("DirtBreak", 0.7f * soundEffectVolume);
	AudioManager.setMaxVolume("HurtSound", 0.75f * soundEffectVolume);
	AudioManager.setMaxVolume("LowHealth", 0.7f * soundEffectVolume);
	// AudioManager.setMaxVolume("treasure", 0.8f * soundEffectVolume);

	for (int i = 1; i < 5; i++)
	{
		AudioManager.setMaxVolume("Explosion" + i, 0.7f * soundEffectVolume);
	}

	for (int i = 1; i < 5; i++)
	{
		AudioManager.setMaxVolume("StoneBreak" + i, 0.7f * soundEffectVolume);
	}

	for (int i = 1; i < 4; i++)
	{
		AudioManager.setMaxVolume("GlassBreak" + i, 0.65f * soundEffectVolume);
	}

	for (int i = 1; i < 4; i++)
	{
		AudioManager.setMaxVolume("JukeboxNum" + i + "Music", 0.55f * musicVolume);
	}
	
	//generateFlippedImages();
	prepareDrawingLayers();

	//setup game and show title screen
	setupGame();
}

// void generateFlippedImages()
// {
// 	ResourceManager.generateFlippedImages("CoalBlock");
// 	ResourceManager.generateFlippedImages("IronBlock");
// 	ResourceManager.generateFlippedImages("DirtBlock");
// 	ResourceManager.generateFlippedImages("StoneBlock");
// }

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
}

void prepareDrawingLayers()
{
	drawList = new ArrayList<ArrayList>();

	for(int i = 0; i < drawingLayers; i++)
	{
		drawList.add(new ArrayList<BaseObject>());
	}
}

void cleanDrawingLayers()
{
	for (ArrayList<BaseObject> drawLayer : drawList)
	{
		drawLayer.clear();
	}
}

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

	//push and pop are needed so the hud can be correctly drawn
	pushMatrix();

	camera.update();

	world.update();
	world.draw();

	drawParallaxLayers();

	updateObjects();
	drawObjects();

	world.updateDepth();

	// needs to happan here because we are inside the push and pop matrix functions
	if (currentGameState == GameState.InGame && player.position.y < (OVERWORLD_HEIGHT + 5) * TILE_SIZE)
	{
		ui.drawArrows();
	}

	popMatrix();
	//draw hud below popMatrix();

	handleGameFlow();

	ui.draw();
}

void userFilledInName()
{
	// tell the game we dont need to show the login screen anymore
	userInLoginScreen = false;

	// save username for next time the game starts
	String[] saveData = new String[1];
	saveData[0] = loginScreen.enteredName;
	saveStrings("DbUser.txt", saveData);

	// begin login with filled in name
	databaseManager.beginLogin(saveData[0]);

	// clean up
	loginScreen = null;
}

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

void handleGameFlow()
{
  switch (currentGameState)
  {
	case MainMenu:
		//if we are in the main menu we start the game by pressing enter
		if (InputHelper.isKeyDown(START_KEY))
		{
			enterOverWorld(false);
		}

		if(InputHelper.isKeyDown(ACHIEVEMENT_SCREEN_KEY))
		{
			currentGameState = GameState.AchievementScreen; 
			ui.achievementScreen();  
			
		}

		break;

	case InGame:
		//Pauze the game
		if (InputHelper.isKeyDown(START_KEY))
		{
			currentGameState = GameState.GamePaused;
			InputHelper.onKeyReleased(START_KEY);
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

		// In the achievement screen press ENTER to exit temp(!)
		if(InputHelper.isKeyDown(START_KEY))
		{
			currentGameState = GameState.MainMenu; 
			InputHelper.onKeyReleased(START_KEY);
		}

		break; 

	case GamePaused:
		gamePaused = true;

		//if the game has been paused the player can continue the game
		if (InputHelper.isKeyDown(START_KEY))
		{
			gamePaused = false;
			currentGameState = GameState.InGame;
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
	currentGameState = GameState.Overworld;
	camera.lerpAmount = 0.075f;
}

void startGameSoon()
{
  	startGame = true;
}

//called when the player pressed the button
void startAsteroidRain()
{
	thread("startRegisterRunThread");

	gamePaused = false;
	currentGameState = GameState.InGame;

	AudioManager.stopMusic("ForestAmbianceMusic");
	AudioManager.loopMusic("BackgroundMusic");
	AudioManager.playSoundEffect("Siren");

	ui.drawWarningOverlay = true;
}

//is called when the played died
void endRun()
{
	isUploadingRunResults = true;
	gamePaused = true;
	currentGameState = GameState.GameOver;
	ui.drawWarningOverlay = false;
	AudioManager.stopMusic("BackgroundMusic");

	thread("startRegisterEndThread");
}

String dots = "";

void handleLoadingScreen()
{
	background(0);

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
		text("Loading", width / 2, height - 10);
	}

	//login
	if(loginStatus != "Logged in")
	{
		//handleDots();
		text(loginStatus + dots, width / 2, height - 55);
	}
	else
	{
		fill(0, 255, 0);
		text("Logged in as " + dbUser.userName, width / 2, height - 55);
	}

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

private void handleDots()
{
	if(frameCount % 20 == 0)
	{
		dots += ".";
	}

	if(dots.length() > 3)
	{
		dots = "";
	}
}

// handles all the basic stuff to add it to the processing stuff, so we can easily change it without copypasting a bunch
BaseObject load(BaseObject newObject)
{
	loadList.add(newObject); //qeue for loading

	return newObject;
}

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

void setupLightSource(BaseObject object, float lightEmitAmount, float dimFactor)
{
	object.lightEmitAmount = lightEmitAmount;
	object.distanceDimFactor = dimFactor;
	lightSources.add(object);
}

ArrayList<BaseObject> getObjectsInRadius(PVector pos, float radius)
{
	ArrayList<BaseObject> objectsInRadius = new ArrayList<BaseObject>();

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

void keyPressed()
{
	InputHelper.onKeyPressed(keyCode);
	InputHelper.onKeyPressed(key);

	//Debug code
	debugInput();
}

void keyReleased()
{
	InputHelper.onKeyReleased(keyCode);
	InputHelper.onKeyReleased(key);
}

void debugInput()
{
	// Test spawns
	if(key == 'E' || key == 'e')
	{
		load(new ScorePickup(50,ResourceManager.getImage("CoalPickup")));
		load(new EnemyDigger(new PVector(1000,500)));

	}

	// if(key == 'R' || key == 'r')
	// {
	// 	databaseManager.updateVariable("poop", 500);
	// }

	// if (key == 'T' || key == 't')
	// {
	// 	databaseManager.insertVariable("poop", 500);
	// }

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

	if(key == 'l')
	{
		load(new Dynamite(), new PVector(player.position.x + 200, player.position.y));
	}

}

