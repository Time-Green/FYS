import http.requests.*;
import java.text.SimpleDateFormat;
import java.util.Date;

public class DatabaseManager{

  // USAGE
  // ArrayList<DbUser> allUsers = databaseManager.getAllUsers();
  // for(DbUser user : allUsers){
  //     println("user.username: " + user.userName);
  // }

  private final String BASE_URL = "https://fys-tui.000webhostapp.com/phpconnect.php?sql=";

  private int currentSessionId = -1;

  public ArrayList<DbUser> getAllUsers(){

    JSONArray result = doDatabaseRequest("SELECT * FROM User");
    ArrayList<DbUser> returnList = new ArrayList<DbUser>();

    for (int i = 0; i < result.size(); i++) {
      returnList.add(buildUser(result.getJSONObject(i)));
    }

    return returnList;
  }

  public boolean userExists(String userName){

    final String COUNT_COLUMN_NAME = "Count";

    JSONArray result = doDatabaseRequest("SELECT COUNT(*) AS " + COUNT_COLUMN_NAME +" FROM User WHERE username = '" + userName + "'");

    if(result.size() == 1){
      return result.getJSONObject(0).getInt(COUNT_COLUMN_NAME) == 1;
    }else{
      return false;
    }
  }

  //used for logging in
  public DbUser getOrCreateUser(String userName){
    
    DbUser user;

    if(userExists(userName)){
      user = getUser(userName);
    }else{
      user = createUser(userName, false);
    }

    registerSessionStart(user);

    return user;
  }

  public DbUser createUser(String userName, boolean checkForUserExists){

    if(checkForUserExists){
      if(userExists(userName)){
        println("ERROR: user '" + userName + "' already exists in the database!");
        return null;
      }
    }

    final String NEW_ID_COLUMN = "id";

    JSONArray result = doDatabaseRequest("INSERT INTO User (`username`) VALUES ('" + userName + "')");

    if(result.size() == 1){

      int newId = result.getJSONObject(0).getInt("LAST_INSERT_ID()");

      return getUser(newId);
    }else{
      return null;
    }
  }

  public boolean registerSessionStart(DbUser loggedInUser){

    SimpleDateFormat formatter = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
    Date date = new Date();

    JSONArray result = doDatabaseRequest("INSERT INTO Playsession (`userid`, `startdatetime`) VALUES ('" + loggedInUser.id + "', '" + formatter.format(date) + "')");

    if(result.size() == 1){

      currentSessionId = result.getJSONObject(0).getInt("LAST_INSERT_ID()");
      println("currentSessionId: " + currentSessionId);
    }

    return currentSessionId >= 0;
  }

  public boolean registerSessionEnd(){

    if(currentSessionId < 0){
      return false;
    }

    SimpleDateFormat formatter = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
    Date date = new Date();

    JSONArray result = doDatabaseRequest("UPDATE Playsession SET enddatetime = '" + formatter.format(date) + "' WHERE id = " + currentSessionId);

    int success = -1;

    if(result.size() == 1){

     success = result.getJSONObject(0).getInt("Success");
    }

    return success == 1;
  }

  public DbUser getUser(int id){

    JSONArray result = doDatabaseRequest("SELECT * FROM User WHERE id = " + id);

    if(result.size() == 1){
      return buildUser(result.getJSONObject(0));
    }else{
      return null;
    }
  }

  public DbUser getUser(String userName){

    JSONArray result = doDatabaseRequest("SELECT * FROM User WHERE username = '" + userName + "'");

    if(result.size() == 1){
      return buildUser(result.getJSONObject(0));
    }else{
      return null;
    }
  }

  private DbUser buildUser(JSONObject jsonUser){

    DbUser user = new DbUser();

    user.id = jsonUser.getInt("id");
    user.userName = jsonUser.getString("username");

    return user;
  }

  public JSONArray doDatabaseRequest(String request){

    String url = BASE_URL + request;

    //encode
    url = url.replace(' ', '+');
    url = url.replace("`", "%60");

    GetRequest get = new GetRequest(url);

    get.addHeader("Accept", "application/json");
    get.send();

    String result = get.getContent();

    //println("request: " + request);
    //println("result: " + result);

    return parseJSONArray(result);
  }

}
