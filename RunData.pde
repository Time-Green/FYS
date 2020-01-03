public class RunData //we track all kinds of data and sent all of it to the database when the run ends!
{
    int playerJumps; 
    int playerBlocksMined; 
    int pickupsPickedUp;
    int itemsUsed;
    float timeToButtonPress; //how long it took us to figure out how the button worked 
    
    ArrayList<Integer> unlockedAchievementIds = new ArrayList<Integer>();
    ArrayList<RelicShard> collectedRelicShards = new ArrayList<RelicShard>();
}
