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
ArrayList<LeaderboardRow> leaderBoard;
ArrayList<Integer> unlockedAchievementIds; 
ArrayList<Achievement> allAchievements; 
ArrayList<Integer> vars;
String loginStatus = "Logging in";
boolean isUploadingRunResults = false;

// used to run code on closing game
DisposeHandler dh;

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
	dh = new DisposeHandler(this);

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

	if(userName.length == 1 && !userName[0].equals(""))
	{
		databaseManager.beginLogin(userName[0]);
	}
	else if(userName.length == 1 && !userName[0].equals(""))
	{
		// if no name was filled in, show login screen
		loginScreen = new LoginScreen();
		userInLoginScreen = true;
	}
	else
	{
		// should not happan...
		println("WARNING DbUser.txt not setup correctly, logging in using username in first line");
		databaseManager.beginLogin(userName[0]);
	}
}

// used for initialisation that need loaded resources
void afterResouceLoadingSetup()
{
	AudioManager.setMaxVolume("Siren", 0.6f);
	AudioManager.setMaxVolume("BackgroundMusic", 0.75f);
	AudioManager.setMaxVolume("ForestAmbianceMusic", 0.7f);
	AudioManager.setMaxVolume("DirtBreak", 0.5f);
	AudioManager.setMaxVolume("HurtSound", 0.75f);
	AudioManager.setMaxVolume("LowHealth", 0.7f);

	for (int i = 1; i < 5; i++)
	{
		AudioManager.setMaxVolume("Explosion" + i, 0.2f);
	}

	for (int i = 1; i < 5; i++)
	{
		AudioManager.setMaxVolume("StoneBreak" + i, 0.5f);
	}

	for (int i = 1; i < 4; i++)
	{
		AudioManager.setMaxVolume("GlassBreak" + i, 0.4f);
	}

	//setup game and show title screen
	setupGame();
}

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

	prepareDrawingLayers();

	runData = new RunData();

	ui = new UIController();

	world = new World();

	player = new Player();
	load(player);

	wallOfDeath = new WallOfDeath();
	load(wallOfDeath);

	camera = new Camera(player);

	AudioManager.loopMusic("ForestAmbianceMusic");

	// update leaderboard texture with new scores
	ui.generateLeaderboardGraphics();
}

void prepareDrawingLayers()
{
	drawList = new ArrayList<ArrayList>();

	for(int i = 0; i < drawingLayers; i++)
	{
		drawList.add(new ArrayList<BaseObject>());
	}
}

void draw()
{
	if(userInLoginScreen)
	{
		loginScreen.update();
		loginScreen.draw();

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

	case GamePaused:
		gamePaused = true;

		//if the game has been paused the player can contineu the game
		if (InputHelper.isKeyDown(START_KEY))
		{
			gamePaused = false;
			currentGameState = GameState.InGame;
			InputHelper.onKeyReleased(START_KEY);
		}

		//Reset game to over world
		if (InputHelper.isKeyDown(BACK_KEY))
		{
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

	//AudioManager.loopMusic("ForestAmbianceMusic"); 
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
	
	ui.setupRunEnd();
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

	// Test spawns
	if(key == 'E' || key == 'e')
	{
		load(new EnemyGhost(new PVector(player.position.x + 200,player.position.y)));
	}

	// if (key == 'I' || key == 'i')
	// {
	// 	load(new Icicle(), new PVector(player.position.x + 200, player.position.y - 200));
	// }

	// if (key == 'G' || key == 'g')
	// {
	// 	load(new Dynamite(), new PVector(player.position.x + 200, player.position.y - 200));
	// }

	// if (key == 'H' || key == 'h')
	// {
	// 	load(new Spike(), new PVector(player.position.x + 200, player.position.y - 200));
	// }
}

void keyReleased()
{
	InputHelper.onKeyReleased(keyCode);
	InputHelper.onKeyReleased(key);
}

