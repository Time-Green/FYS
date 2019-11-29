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

            JSONObject userJsonObject = result.getJSONObject(i);
            DbUser user = new DbUser();

            user.id = userJsonObject.getInt("id");
            user.userName = userJsonObject.getString("username");

            returnList.add(user);
        }

        return returnList;
    }

    public JSONArray doDatabaseRequest(String request){

        String url = BASE_URL + request;

        url = url.replace(' ', '+'); //encode

        GetRequest get = new GetRequest(url);

        get.addHeader("Accept", "application/json");
        get.send();

        String result = get.getContent();

        return parseJSONArray(result);
    }

}
