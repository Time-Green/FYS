import http.requests.*;
import java.text.SimpleDateFormat;
import java.util.Date;

public class DatabaseManager
{
	private final String BASE_URL = "https://fys-tui.000webhostapp.com/phpconnect.php?sql=";

	private int currentSessionId = -1;
	private int currentRunId = -1;

	public ArrayList<DbUser> getAllUsers()
	{

		JSONArray result = doDatabaseRequest("SELECT * FROM User");
		ArrayList<DbUser> returnList = new ArrayList<DbUser>();

		for (int i = 0; i < result.size(); i++) {
			returnList.add(buildUser(result.getJSONObject(i)));
		}

		return returnList;
	}

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

	//used for logging in
	public DbUser getOrCreateUser(String userName)
	{
		DbUser user = getUser(userName);

		if (user == null) {
			user = createUser(userName, false);
		}

		registerSessionStart(user);

		return user;
	}

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
    
	// for(int i = 0; i < returnList.size(); i++)
	// {
	// 	println(returnList.get(i)); 
	// }

    return returnList; 
  }

  //get all the currently available achievements
  public ArrayList<Achievement> getAllAchievements() 
  {
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
	
	return true; 
  }

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

  public ArrayList<PlayerRelicInventory> getPlayerRelicInventory() {

    if (currentSessionId < 0) {
      return new ArrayList<PlayerRelicInventory>();
    }

    JSONArray result = doDatabaseRequest("SELECT * FROM Relicinventory WHERE userid = " + dbUser.id);
    ArrayList<PlayerRelicInventory> returnList = new ArrayList<PlayerRelicInventory>();

    for (int i = 0; i < result.size(); i++) {
      returnList.add(buildPlayerRelicInventory(result.getJSONObject(i)));
    }

    return returnList;
  }

  public ArrayList<LeaderboardRow> getLeaderboard(int amount) {

    if (currentSessionId < 0) {
      return new ArrayList<LeaderboardRow>();
    }

    JSONArray result = doDatabaseRequest("SELECT u.username, MAX(r.score) score, MAX(r.depth) depth FROM Run r INNER JOIN Playsession p ON r.playsessionid = p.id INNER JOIN User u ON p.userid = u.id WHERE r.score IS NOT NULL GROUP BY u.username ORDER BY MAX(r.score) DESC LIMIT " + amount);
    ArrayList<LeaderboardRow> returnList = new ArrayList<LeaderboardRow>();

    for (int i = 0; i < result.size(); i++) {
      returnList.add(buildLeaderboardRow(result.getJSONObject(i)));
    }

    return returnList;
  }

  public boolean registerRunEnd() {

    if (currentSessionId < 0 || currentRunId < 0) {
      return false;
    }

    boolean updateRunDataSucces = updateRunData();
    boolean updatePlayerRelicSucces = updatePlayerRelicInventory();
    boolean updatePlayerAchievementSucces = updatePlayerAchievements();

    return updateRunDataSucces && updatePlayerRelicSucces;
  }

  private boolean updateRunData() {

    if (currentSessionId < 0) {
      return false;
    }

    SimpleDateFormat formatter = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
    Date date = new Date();

    JSONArray result = doDatabaseRequest("UPDATE Run SET enddatetime = '" + formatter.format(date) + "', score = '" + player.score + "', depth = '" + (player.getDepth() - Globals.OVERWORLD_HEIGHT) + "', jumps = '" + runData.playerJumps + "', pickups = '" + runData.pickUpsPickedUp + "', blocksmined = '" + runData.playerBlocksMined + "' WHERE id = " + currentRunId);

    int success = -1;

    if (result.size() == 1) {

      success = result.getJSONObject(0).getInt("Success");
    }

    return success == 1;
  }

  public DbUser getUser(int id) {

    JSONArray result = doDatabaseRequest("SELECT * FROM User WHERE id = " + id);

    if (result.size() == 1) {
      return buildUser(result.getJSONObject(0));
    } else {
      return null;
    }
  }

  public DbUser getUser(String userName) {

    JSONArray result = doDatabaseRequest("SELECT * FROM User WHERE username = '" + userName + "'");

    if (result.size() == 1) {
      return buildUser(result.getJSONObject(0));
    } else {
      return null;
    }
  }

  public boolean updatePlayerRelicInventory() {

    if (currentSessionId < 0) {
      return false;
    }

    ArrayList<RelicShard> collectedRelicShards = runData.collectedRelicShards;
    boolean success = true;

    for(RelicShard collectedRelicShard : collectedRelicShards) {
      PlayerRelicInventory playerRelicInventory = getPlayerRelicInventory(collectedRelicShard);

      if (playerRelicInventory == null) {
        boolean result = insertPlayerRelicInventory(collectedRelicShard);
        if(result == false){
          success = false;
        }
      }
      else{
        boolean result = incrementPlayerRelicInventory(collectedRelicShard, playerRelicInventory);
         if(result == false){
          success = false;
        }
      }
    }
    
    return success;
  }

  //check if player has the relicshard.
  private PlayerRelicInventory getPlayerRelicInventory(RelicShard collectedRelicShard) {

    JSONArray result = doDatabaseRequest("SELECT * FROM Relicinventory WHERE userid = " + dbUser.id + " AND relicshardid =" + collectedRelicShard.type);

    if (result.size() == 1) {
      return buildPlayerRelicInventory(result.getJSONObject(0));
    } else {
      return null;
    }
  }

  //if not insert new row with this relic id
  private boolean insertPlayerRelicInventory(RelicShard collectedRelicShard) {

    JSONArray result = doDatabaseRequest("INSERT INTO Relicinventory (`userid`, `relicshardid`, `amount`) VALUES ('" + dbUser.id + "', '" + collectedRelicShard.type + "', '1')");

    int newId = -1;

    if (result.size() == 1) {

     newId = result.getJSONObject(0).getInt("LAST_INSERT_ID()");
    } 

    return newId > -1;
  }

  //if it does exist increment the amount for relic update
  private boolean incrementPlayerRelicInventory(RelicShard collectedRelicShard, PlayerRelicInventory playerRelicInventory) {

    JSONArray result = doDatabaseRequest("UPDATE Relicinventory SET amount = '" + (playerRelicInventory.amount + 1) + "' WHERE id = " + playerRelicInventory.id);

    int success = -1;

    if (result.size() == 1) {

      success = result.getJSONObject(0).getInt("Success");
    }

    return success == 1;  
  }

  private DbUser buildUser(JSONObject jsonUser) {

    DbUser user = new DbUser();

    user.id = jsonUser.getInt("id");
    user.userName = jsonUser.getString("username");

    return user;
  }

   private PlayerRelicInventory buildPlayerRelicInventory(JSONObject json) {

    PlayerRelicInventory playerRelicInventory = new PlayerRelicInventory();

    playerRelicInventory.id = json.getInt("id");
    playerRelicInventory.userid = json.getInt("userid");
    playerRelicInventory.relicshardid = json.getInt("relicshardid");
    playerRelicInventory.amount = json.getInt("amount");

    return playerRelicInventory;
  }

  private Achievement buildAchievement(JSONObject json) {

    Achievement achievement = new Achievement();

    achievement.id = json.getInt("id");
    achievement.name = json.getString("name");
    achievement.description = json.getString("description");

	//println("Achievement: " + achievement.id + ", " + achievement.name);

    return achievement;
  }
  
  private LeaderboardRow buildLeaderboardRow(JSONObject json) {

    LeaderboardRow leaderboardRow = new LeaderboardRow();

    leaderboardRow.userName = json.getString("username");
    leaderboardRow.score = json.getInt("score");
    leaderboardRow.depth = json.getInt("depth");

    return leaderboardRow;
  }

  public JSONArray doDatabaseRequest(String request) {

    String url = BASE_URL + request;

    //encode
    url = url.replace(' ', '+');
    url = url.replace("`", "%60");

    GetRequest get = new GetRequest(url);

    get.addHeader("Accept", "application/json");
    get.send();

    String result = get.getContent();

    //  println("request: " + request);
    //  println("result: " + result);

    return parseJSONArray(result);
  }

  void beginLogin() {
    loginStartTime = millis();
    thread("login");
  }

  //used to log in using its own thread
  void login() {

    try {
      String[] lines = loadStrings("DbUser.txt");

      if (lines.length != 1) {
        println("ERROR: DbUser.txt file not corretly set up, using temporary user");
        setTempUser();
      } else {
        String currentUserName = lines[0];
        println("Logging in as '" + currentUserName + "'");
        dbUser = databaseManager.getOrCreateUser(currentUserName);
      }
    }
    catch(Exception e) {
      setTempUser();

      println("ERROR: Unable to connect to database or DbUser.txt file not found, using temporary user");
    }

    println("Successfully logged in as '" + dbUser.userName + "', took " + (millis() - loginStartTime) + " ms");
  }

  void setTempUser() {
    dbUser = new DbUser();
    dbUser.id = -1;
    dbUser.userName = "TempUser";
  }

  int getUserTotal(String userid, String data){ //get a given userid's total data. like total amount of jumps across all games
    JSONArray result = doDatabaseRequest("SELECT SUM(" + data + ") as" + data + " FROM Playsession, Run WHERE Playsession.id = Run.playsessionid AND Playsession.userid = '" + userid + ";");
    try{
      return result.getInt(0);
    }
    catch(Exception e){
      return 0;
    }
  }
}
