final boolean PRINT_LOADING_DEBUG = false;

// used to login the user and start loading resources
void loginThread() 
{
	loginStatus = "Logging in as " + databaseManager.userNameToLogin;
	databaseManager.loginUser();

	loginStatus = "Loading data";
	thread("loadPlayerInventoryThread");
	thread("loadAllAchievementsThread");
	thread("loadPlayerAchievementsThread");
	thread("loadLeaderboardThread");
    thread("loadDatabaseVariables");
}

// called in its own thread, loads the player inventory
void loadPlayerInventoryThread()
{
    int startTime = millis();

    if(PRINT_LOADING_DEBUG)
    {
        println("Loading player inventory");
    }
	
	totalCollectedRelicShards = databaseManager.getPlayerRelicInventory();
	loadedPlayerInventory = true;

    if(PRINT_LOADING_DEBUG)
    {
	    println("Loaded player inventory in " + (millis() - startTime) + "ms : " + totalCollectedRelicShards);
    }
}

// called in its own thread, loads all achievements
void loadAllAchievementsThread()
{
    int startTime = millis();

    if(PRINT_LOADING_DEBUG)
    {
	    println("Loading all achievements");
    }

	allAchievements = databaseManager.getAllAchievements();
    allAchievementsRarity = databaseManager.getAchievementRarity(); 
	loadedAllAchievements = true;

    if(PRINT_LOADING_DEBUG)
    {
	    println("Loaded all achievements in " + (millis() - startTime) + "ms : " + allAchievements);
    }
}

// called in its own thread, loads the player achievements
void loadPlayerAchievementsThread()
{
    int startTime = millis();

    if(PRINT_LOADING_DEBUG)
    {
	    println("Loading player achievements");
    }

	unlockedAchievementIds = databaseManager.getPlayerUnlockedAchievementIds();
	loadedPlayerAchievements = true;

    if(PRINT_LOADING_DEBUG)
    {
	    println("Loaded player achievements in " + (millis() - startTime) + "ms : " + unlockedAchievementIds);
    }
}

// called in its own thread, loads the leaderboard
void loadLeaderboardThread()
{
    int startTime = millis();

    if(PRINT_LOADING_DEBUG)
    {
	    println("Loading leaderboard");
    }

	leaderBoard = databaseManager.getLeaderboard(10);
	loadedLeaderboard = true;

    if(PRINT_LOADING_DEBUG)
    {
	    println("Loaded leaderboard in " + (millis() - startTime) + "ms : " + leaderBoard);
    }
}

// called in its own thread, loads the scoreboard
void loadDatabaseVariables()
{
    int startTime = millis();

    if(PRINT_LOADING_DEBUG)
    {
	    println("Loading scoreboard");
    }

	scoreboard = databaseManager.getAllPickupScores();
    databaseVariables = databaseManager.getAllDatabaseVariables();
	loadedScores = true;

    if(PRINT_LOADING_DEBUG)
    {
	    println("Loaded scoreboard in " + (millis() - startTime) + "ms : " + scoreboard);
    }
}

// start a thread to load 1 resource with given name and path
void startLoaderThread(String currentResourceName, String currentResourceFileName)
{
	LoaderThread loaderThread = new LoaderThread(currentResourceName, currentResourceFileName);
	ResourceManager.loaderThreads.add(loaderThread);
	loaderThread.start();
}

// start a thread that registers a run start
void startRegisterRunThread()
{
  	databaseManager.registerRunStart();
}

// start a thread that registers a run end
void startRegisterEndThread()
{
	databaseManager.registerRunEnd();

  	unlockedAchievementIds.addAll(runData.unlockedAchievementIds); 

  	//update leaderboard with new data
  	leaderBoard = databaseManager.getLeaderboard(10);

	isUploadingRunResults = false;
}