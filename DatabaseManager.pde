import http.requests.*;

public class DatabaseManager{

  // USAGE
  // ArrayList<DbUser> allUsers = databaseManager.getAllUsers();
  // for(DbUser user : allUsers){
  //     println("user.username: " + user.userName);
  // }

  private final String BASE_URL = "https://fys-tui.000webhostapp.com/phpconnect.php?sql=";

  public ArrayList<DbUser> getAllUsers(){

    JSONArray result = doDatabaseRequest("SELECT * FROM User");
    ArrayList<DbUser> returnList = new ArrayList<DbUser>();

    for (int i = 0; i < result.size(); i++) {
      returnList.add(buildUser(result.getJSONObject(i)));
    }

    return returnList;
  }

  public DbUser getUser(int id){

    JSONArray result = doDatabaseRequest("SELECT * FROM User WHERE id = " + id);

    if(result.size() == 1){
      return buildUser(result.getJSONObject(0));
    }else{
      return null;
    }
  }

  public DbUser getUser(String name){

    JSONArray result = doDatabaseRequest("SELECT * FROM User WHERE username = " + name);

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

    url = url.replace(' ', '+'); //encode

    GetRequest get = new GetRequest(url);

    get.addHeader("Accept", "application/json");
    get.send();

    String result = get.getContent();

    println("request: " + request);
    println("result: " + result);

    return parseJSONArray(result);
  }

}
