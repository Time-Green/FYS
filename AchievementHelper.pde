public class AchievementHelper
{

    // 0 - Lone Digger (player has dug more than 100 tiles)

    void unlock(int id)
    {
        // when we are not connected to the database, we cant unlock achievements
        if(databaseManager.currentSessionId == -1)
        {
            return;
        }

        if(achievementExists(id))
        {
             println("Player " + dbUser.userName + " has unlocked: "+ getAchievementData(id).name);
             runData.unlockedAchievementIds.add(id); 
             ui.startDisplayingAchievement(id); 
        }
        else
        {
            println("The given achievement id does not exist"); 
            return; 
        }
       
    }  

    Achievement getAchievementData(int id)
    {
        for(Achievement achievement : allAchievements)
        {
            if(achievement.id == id)
            {
                return achievement; 
            }
        }

        return null; 
    }  

    boolean hasUnlockedAchievement(int id)
    {
        for(int achievement : unlockedAchievementIds)
        {
            if(achievement == id)
            {
                return true;
            }
        }

        for(int achievement : runData.unlockedAchievementIds)
        {
            if(achievement == id)
            {
                return true;
            }
        }

        return false;    
    }

    // Quick check whether the given id exist
    boolean achievementExists(int id)
    {
        for(Achievement achievement : allAchievements)
        {
            if(achievement.id == id)
            {
                return true;
            }
        }     

        return false;    
    }
}

public class achievementImageFrame
{

    public float frameSize = 170; 
    public float xPosition; 
    public int achievementId; 
    public float moveAmount = frameSize; 

    achievementImageFrame(int x, int id)
    {
        xPosition = width / 2 + (180 * x); 
        achievementId = id; 
    }

    void draw()
    {
        fill(255); 
        rect(xPosition, height/3, frameSize, frameSize);
    }

    void move(boolean direction)
    {    
        if(!direction)
        {
            xPosition -= moveAmount; 
        }
        
        else
        {
            xPosition += moveAmount; 
        }

        return; 
        
    }
}
