import http.requests.*;
import java.text.SimpleDateFormat;
import java.util.Date;

//jonah needs help

public class DatabaseManager
{
	private final String BASE_URL = "https://fys-tui.000webhostapp.com/phpconnect.php?sql=";
	private final boolean PRINT_DATABASE_DEBUG = false;

	public String userNameToLogin;

	private int currentSessionId = -1;
	private int currentRunId = -1;

	//get all data from all users
	public ArrayList<DbUser> getAllUsers()
	{
		JSONArray result = doDatabaseRequest("SELECT * FROM User");
		ArrayList<DbUser> returnList = new ArrayList<DbUser>();

		for (int i = 0; i < result.size(); i++) {
			returnList.add(buildUser(result.getJSONObject(i)));
		}

		return returnList;
	}

	// check if a user exists in the database
	public boolean userExists(String userName)
	{
		final String COUNT_COLUMN_NAME = "Count";

		JSONArray result = doDatabaseRequest("SELECT COUNT(*) AS " + COUNT_COLUMN_NAME +" FROM User WHERE username = '" + userName + "'");

		if (result.size() == 1)
		{
			return result.getJSONObject(0).getInt(COUNT_COLUMN_NAME) == 1;
		}
		else
		{
			return false;
		}
	}

	//used for logging in, gets a user if it exists, else create one and return it
	public DbUser getOrCreateUser(String userName)
	{
		DbUser user = getUser(userName);

		if (user == null)
		{
			user = createUser(userName, false);
		}

		registerSessionStart(user);

		return user;
	}

	// create a new user in the database and return it
	public DbUser createUser(String userName, boolean checkForUserExists)
	{
		if (checkForUserExists)
		{
			if (userExists(userName))
			{
				println("ERROR: user '" + userName + "' already exists in the database!");

				return null;
			}
		}

		final String NEW_ID_COLUMN = "id";

		JSONArray result = doDatabaseRequest("INSERT INTO User (`username`) VALUES ('" + userName + "')");

		if (result.size() == 1)
		{
			int newId = result.getJSONObject(0).getInt("LAST_INSERT_ID()");

			return getUser(newId);
		}
		else
		{
			return null;
		}
	}

	// notify the database that this player has quit the game
	public boolean registerSessionStart(DbUser loggedInUser)
	{
		try
		{
			SimpleDateFormat formatter = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
			Date date = new Date();

			JSONArray result = doDatabaseRequest("INSERT INTO Playsession (`userid`, `startdatetime`) VALUES ('" + loggedInUser.id + "', '" + formatter.format(date) + "')");

			if (result.size() == 1) {
				currentSessionId = result.getJSONObject(0).getInt("LAST_INSERT_ID()");
			}

			return currentSessionId >= 0;
		}
		catch(Exception e)
		{
			println("Could not connect to database, do you have an internet connection?");
			currentSessionId = -1;

			return false;
		}
	}

	// notify the database that this player has quit the game
	public boolean registerSessionEnd()
	{
		if (currentSessionId < 0)
		{
			return false;
		}

		SimpleDateFormat formatter = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
		Date date = new Date();

		JSONArray result = doDatabaseRequest("UPDATE Playsession SET enddatetime = '" + formatter.format(date) + "' WHERE id = " + currentSessionId);

		int success = -1;

		if (result.size() == 1)
		{
			success = result.getJSONObject(0).getInt("Success");
		}

		return success == 1;
	}

	// notify the database that this player has started a run
	public boolean registerRunStart()
    {
        if (currentSessionId < 0)
        {
            return false;
        }

        SimpleDateFormat formatter = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
        Date date = new Date();

        JSONArray result = doDatabaseRequest("INSERT INTO Run (playsessionid, startdatetime) VALUES ('" + currentSessionId + "', '" + formatter.format(date) + "')");

        if (result.size() == 1)
        {
            currentRunId = result.getJSONObject(0).getInt("LAST_INSERT_ID()");
        }

        return currentRunId >= 0;
    }

	// get all the unlocked achievements from the current player
	public ArrayList<Achievement> getPlayerAchievements() 
	{
		if (currentSessionId < 0) 
		{
			return new ArrayList<Achievement>();
		}

		JSONArray result = doDatabaseRequest("SELECT A.id, A.name, A.description FROM Achievement AS A INNER JOIN UnlockedAchievement ON UnlockedAchievement.achievementid = A.id WHERE UnlockedAchievement.playerid = " + dbUser.id);
		ArrayList<Achievement> returnList = new ArrayList<Achievement>();

		for (int i = 0; i < result.size(); i++) 
		{
			returnList.add(buildAchievement(result.getJSONObject(i)));
		}
		
		return returnList;
		
	}

	// get all the unlocked achievement ids from the current player
	public ArrayList<Integer> getPlayerUnlockedAchievementIds() 
	{
		if (currentSessionId < 0) 
		{
			return new ArrayList<Integer>();
		}

		JSONArray result = doDatabaseRequest("SELECT achievementid FROM UnlockedAchievement WHERE playerid = " + dbUser.id);
		ArrayList<Integer> returnList = new ArrayList<Integer>();

		for (int i = 0; i < result.size(); i++) 
		{
			returnList.add(result.getJSONObject(i).getInt("achievementid")); 
		}

		return returnList; 
	}

	//get all the currently available achievements
	public ArrayList<Achievement> getAllAchievements() 
	{
		if (currentSessionId < 0) 
		{
			return new ArrayList<Achievement>();
		}

		JSONArray result = doDatabaseRequest("SELECT * FROM Achievement");

		ArrayList<Achievement> returnList = new ArrayList<Achievement>(); 

		for (int i = 0; i < result.size(); i++) 
		{
			returnList.add(buildAchievement(result.getJSONObject(i)));
		}

		return returnList; 
	}

	//if not insert new row with this user id and achievement id
	private boolean insertNewAchievement(int unlockedAchievementId) 
	{
		JSONArray result = doDatabaseRequest("INSERT INTO UnlockedAchievement (`playerid`, `achievementid`) VALUES ('" + dbUser.id + "', '" + unlockedAchievementId + "')");
		
		int newId = -1;

		if (result.size() == 1)
		{
			newId = result.getJSONObject(0).getInt("LAST_INSERT_ID()");
		} 

		return newId > -1;
	}

	// get the top 'amount' leaderboard rows
	public ArrayList<LeaderboardRow> getLeaderboard(int amount)
	{
		if (currentSessionId < 0)
		{
			return new ArrayList<LeaderboardRow>();
		}

		JSONArray result = doDatabaseRequest("SELECT u.username, MAX(r.score) score, MAX(r.depth) depth FROM Run r INNER JOIN Playsession p ON r.playsessionid = p.id INNER JOIN User u ON p.userid = u.id WHERE r.score IS NOT NULL GROUP BY u.username ORDER BY MAX(r.score) DESC LIMIT " + amount);
		ArrayList<LeaderboardRow> returnList = new ArrayList<LeaderboardRow>();

		for (int i = 0; i < result.size(); i++)
		{
			returnList.add(buildLeaderboardRow(result.getJSONObject(i)));
		}

		return returnList;
	}

	// upload current run data at the end of a run
	public boolean registerRunEnd()
	{
		if (currentSessionId < 0 || currentRunId < 0)
		{
			return false;
		}

		boolean updateRunDataSucces = updateRunData();
		boolean updatePlayerRelicSucces = updatePlayerRelicInventory();
		boolean updatePlayerAchievementSucces = updatePlayerAchievements();

		return updateRunDataSucces && updatePlayerRelicSucces;
	}

	// update run data at end of run
	private boolean updateRunData()
	{
		if (currentSessionId < 0)
		{
			return false;
		}

		SimpleDateFormat formatter = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
		Date date = new Date();

		JSONArray result = doDatabaseRequest("UPDATE Run SET enddatetime = '" + formatter.format(date) + "', score = '" + player.score + "', depth = '" + (player.getDepth() - OVERWORLD_HEIGHT) + "', jumps = '" + runData.playerJumps + "', Pickups = '" + runData.pickupsPickedUp + "', blocksmined = '" + runData.playerBlocksMined + "' WHERE id = " + currentRunId);

		int success = -1;

		if (result.size() == 1)
		{
			success = result.getJSONObject(0).getInt("Success");
		}

		return success == 1;
	}

	// get all relics this player has collected
	public ArrayList<PlayerRelicInventory> getPlayerRelicInventory()
	{
		if (currentSessionId < 0)
		{
			return new ArrayList<PlayerRelicInventory>();
		}

		JSONArray result = doDatabaseRequest("SELECT * FROM Relicinventory WHERE userid = " + dbUser.id);
		ArrayList<PlayerRelicInventory> returnList = new ArrayList<PlayerRelicInventory>();

		for (int i = 0; i < result.size(); i++)
		{
			returnList.add(buildPlayerRelicInventory(result.getJSONObject(i)));
		}

		return returnList;
	}

	// get a user by id
	public DbUser getUser(int id)
	{
		JSONArray result = doDatabaseRequest("SELECT * FROM User WHERE id = " + id);

		if (result.size() == 1)
		{
			return buildUser(result.getJSONObject(0));
		}
		else
		{
			return null;
		}
	}

	// get a user by username
	public DbUser getUser(String userName)
	{
		JSONArray result = doDatabaseRequest("SELECT * FROM User WHERE username = '" + userName + "'");

		if (result.size() == 1)
		{
			return buildUser(result.getJSONObject(0));
		}
		else
		{
			return null;
		}
	}

	public boolean updatePlayerRelicInventory()
	{
		if (currentSessionId < 0)
		{
			return false;
		}

		ArrayList<RelicShard> collectedRelicShards = runData.collectedRelicShards;
		boolean success = true;

		for(RelicShard collectedRelicShard : collectedRelicShards)
		{
			PlayerRelicInventory playerRelicInventory = getPlayerRelicInventory(collectedRelicShard);

			if (playerRelicInventory == null)
			{
				boolean result = insertPlayerRelicInventory(collectedRelicShard);

				if(result == false)
				{
					success = false;
				}
			}
			else
			{
				boolean result = incrementPlayerRelicInventory(collectedRelicShard, playerRelicInventory);

				if(result == false)
				{
					success = false;
				}
			}
		}
		
		return success;
	}

	// upload gained achievements to the database
	public boolean updatePlayerAchievements() 
	{
		if (currentSessionId < 0) 
		{
			return false;
		}

		ArrayList<Integer> unlockedAchievementIds = runData.unlockedAchievementIds;
		boolean success = true;

		for(int unlockedAchievementId : unlockedAchievementIds)
		{
			boolean result = insertNewAchievement(unlockedAchievementId);
			
			if(result == false)
			{
				success = false;
			}
		}
		
		return success;
	}

	//check if player has the relicshard.
	private PlayerRelicInventory getPlayerRelicInventory(RelicShard collectedRelicShard)
	{
		JSONArray result = doDatabaseRequest("SELECT * FROM Relicinventory WHERE userid = " + dbUser.id + " AND relicshardid =" + collectedRelicShard.type);

		if (result.size() == 1)
		{
			return buildPlayerRelicInventory(result.getJSONObject(0));
		}
		else
		{
			return null;
		}
	}

	//if not insert new row with this relic id
	private boolean insertPlayerRelicInventory(RelicShard collectedRelicShard)
	{
		JSONArray result = doDatabaseRequest("INSERT INTO Relicinventory (`userid`, `relicshardid`, `amount`) VALUES ('" + dbUser.id + "', '" + collectedRelicShard.type + "', '1')");

		int newId = -1;

		if (result.size() == 1)
		{
			newId = result.getJSONObject(0).getInt("LAST_INSERT_ID()");
		} 

		return newId > -1;
	}

	//if it does exist increment the amount for relic update
	private boolean incrementPlayerRelicInventory(RelicShard collectedRelicShard, PlayerRelicInventory playerRelicInventory)
	{
		JSONArray result = doDatabaseRequest("UPDATE Relicinventory SET amount = '" + (playerRelicInventory.amount + 1) + "' WHERE id = " + playerRelicInventory.id);

		int success = -1;

		if (result.size() == 1)
		{
			success = result.getJSONObject(0).getInt("Success");
		}

		return success == 1;  
	}

	// converts json object to DbUser class
	private DbUser buildUser(JSONObject jsonUser)
	{
		DbUser user = new DbUser();

		user.id = jsonUser.getInt("id");
		user.userName = jsonUser.getString("username");

		return user;
	}

	// converts json object to PlayerRelicInventory class
	private PlayerRelicInventory buildPlayerRelicInventory(JSONObject json)
	{
		PlayerRelicInventory playerRelicInventory = new PlayerRelicInventory();

		playerRelicInventory.id = json.getInt("id");
		playerRelicInventory.userid = json.getInt("userid");
		playerRelicInventory.relicshardid = json.getInt("relicshardid");
		playerRelicInventory.amount = json.getInt("amount");

		return playerRelicInventory;
	}

	// converts json object to Achievement class
	private Achievement buildAchievement(JSONObject json)
	{
		Achievement achievement = new Achievement();

		achievement.id = json.getInt("id");
		achievement.name = json.getString("name");
		achievement.description = json.getString("description");

		//println("Achievement: " + achievement.id + ", " + achievement.name);

		return achievement;
	}

	// converts json object to LeaderboardRow class
	private LeaderboardRow buildLeaderboardRow(JSONObject json)
	{
		LeaderboardRow leaderboardRow = new LeaderboardRow();

		leaderboardRow.userName = json.getString("username");
		leaderboardRow.score = json.getInt("score");
		leaderboardRow.depth = json.getInt("depth");

		return leaderboardRow;
	}

	public JSONArray doDatabaseRequest(String request)
	{
		String url = BASE_URL + request;

		//encode
		url = url.replace(' ', '+');
		url = url.replace("%", "%25");
		url = url.replace("`", "%60");

		GetRequest get = new GetRequest(url);

		get.addHeader("Accept", "application/json");
		get.send();

		String result = get.getContent();

		if(PRINT_DATABASE_DEBUG)
		{
			println("request: " + request);
			println("result: " + result);
		}

		return parseJSONArray(result);
	}

	void beginLogin(String userNameToLogin)
	{
		this.userNameToLogin = userNameToLogin;
		loginStartTime = millis();

		// calls login function in FYS main file
		thread("loginThread");
	}

  	// used to log in using its own thread
  	void loginUser()
  	{
		try
		{
			if(userNameToLogin.equals(""))
			{
				throw new Exception("Invalid username");
			}

			println("Logging in as '" + userNameToLogin + "'");
			dbUser = getOrCreateUser(userNameToLogin);
		}
		catch(Exception e)
		{
			println("ERROR: Unable to connect to database, using temporary user");
			setTempUser();
		}

		println("Successfully logged in as '" + dbUser.userName + "', took " + (millis() - loginStartTime) + " ms");
  	}

	// when we cant log in, set the dbUser to a temporary user
	void setTempUser()
	{
		dbUser = new DbUser();

		dbUser.id = -1;
		dbUser.userName = "TempUser";

		// set currentSessionId to -1 to indicate this session is invalid/offline
		currentSessionId = -1;
	}

	// get a given userid's total data. like total amount of jumps across all games
	int getUserTotal(String userid, String data)
	{ 
		JSONArray result = doDatabaseRequest("SELECT SUM(" + data + ") as" + data + " FROM Playsession, Run WHERE Playsession.id = Run.playsessionid AND Playsession.userid = '" + userid + ";");

		try
		{
			return result.getInt(0);
		}
		catch(Exception e)
		{
			return 0;
		}
	}

	//Get variables from database

	//Get all variables
	public void getAllVariable()
	{
		JSONArray result = doDatabaseRequest("SELECT * FROM Intvariables");

		for (int i = 0; i < result.size(); i++)
		{
			println(result.getJSONObject(i));
		}

	}

	//Get a specific value from the database
	public float getValue(String variableName)
	{
		// Select the row we need
		JSONArray result = doDatabaseRequest("SELECT * FROM Intvariables WHERE name LIKE " + variableName + ";");
		// Get the float from that row and return it
		float value = result.getJSONObject(0).getFloat("value");

		return value;
	}

	public void updateVariable(String variableName, float newValue)
	{
		// Update the value of the selected variable
		JSONArray result = doDatabaseRequest("UPDATE Intvariables SET value = " + newValue + " WHERE Intvariables.name = '" + variableName + "';");
	}

	public void insertVariable(String variableName, int value)
	{
		//Insert a new row in the database
		JSONArray result = doDatabaseRequest("INSERT INTO Intvariables (name, value, canEdit) VALUES ('"+variableName+"', '"+value+"', '0');");
	}

	//over
	public void insertVariable(String variableName, int value, int allowEdit)
	{
		//Insert a new row in the database
		JSONArray result = doDatabaseRequest("INSERT INTO `Intvariables` (name, value, canEdit) VALUES ('"+variableName+"', '"+value+"', '"+allowEdit+"');");
	}

	public void deleteVariable(String variableName)
	{
		//Insert a new row in the database
		JSONArray result = doDatabaseRequest("DELETE FROM Intvariables WHERE name = '"+variableName+"';");
	}

	public ArrayList<ScoreboardRow> getAllPickupScores()
	{
		//Get all rows that have PickupValue in their name,
		//We also remove 'value'  from their name because we can use that to get images
		JSONArray result = doDatabaseRequest("SELECT left(name, LOCATE('value', name) - 1) as Stone, value as Points FROM Intvariables WHERE name LIKE '%PickupValue' ORDER BY Intvariables.value ASC;");
		ArrayList<ScoreboardRow> returnList = new ArrayList<ScoreboardRow>();
		//Add all returbn word into a arraylist
		for (int i = 0; i < result.size(); i++)
		{
			returnList.add(buildScoreboardRow(result.getJSONObject(i)));
		}

		return returnList;

	}

	private ScoreboardRow buildScoreboardRow(JSONObject json)
	{
		ScoreboardRow scoreboardRow = new ScoreboardRow();

		scoreboardRow.imageName = json.getString("Stone");
		scoreboardRow.score = json.getInt("Points");

		return scoreboardRow;
	}
	
}
