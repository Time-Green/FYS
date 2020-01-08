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
    public float minFrameSize = 150;
    public float currentFrameSize = minFrameSize; 
    public float maxFrameSize = 200; 
    public float frameSpaceBetween = 0.5f; 
    public String lockedAchievementText = "???"; 
    public float x; 
    public float y;
    public int achievementId; 

    achievementImageFrame(int posX, int id)
    {
        x = width/2 + (160 * posX); 
        achievementId = id; 
    }

    void draw()
    {
        y = height/2; 

        for(int i = 0; i < ui.achievementFrames.size(); i++)
        {
            if(CollisionHelper.lineRect(width/2, 0, width/2, height, ui.achievementFrames.get(i).x, ui.achievementFrames.get(i).y, currentFrameSize, currentFrameSize))
            {
                ui.achievementFrames.get(i).inflate(i);               
                textSize(ui.achievementUiSize);
                text(achievementHelper.getAchievementData(ui.achievementFrames.get(i).achievementId).name, width/2, height-200);

                if(achievementHelper.hasUnlockedAchievement(ui.achievementFrames.get(i).achievementId))
                {
                    text(achievementHelper.getAchievementData(ui.achievementFrames.get(i).achievementId).description, width/2, height-100);
                }
                else
                {
                    text(lockedAchievementText, width/2, height-100); 
                }          
            }   
            else
            {
                ui.achievementFrames.get(i).deflate(i);
            }
        }

        fill(255); 
        rect(x, y, currentFrameSize, currentFrameSize);         
    } 
       
    void inflate(int i)
    {
        if(currentFrameSize >= maxFrameSize)
        {
            return; 
        }

        try
        {
            for(int y = i; y > 0; y--)
            {
                ui.achievementFrames.get(y).x -= frameSpaceBetween;     
            }

            for(int y = i; y < ui.achievementFrames.size(); y++)
            {
                ui.achievementFrames.get(y).x += frameSpaceBetween;     
            }      
        }

        catch (Exception e) 
        {
            return;
        }
           
        currentFrameSize++; 
    }

    void deflate(int i)
    {
        if(currentFrameSize <= minFrameSize)
        {
            return; 
        }

        try
        {
            for(int y = i; y > 0; y--)
            {
                ui.achievementFrames.get(y).x += frameSpaceBetween;     
            }

            for(int y = i; y < ui.achievementFrames.size(); y++)
            {
                ui.achievementFrames.get(y).x -= frameSpaceBetween;     
            }  
        }

        catch (Exception e) 
        {
            return; 
        }

        currentFrameSize--; 
    }

    void moveLeft(int first)
    {    
        if(first <= 0)
        {
            return; 
        }

        x -= minFrameSize; 
       
    }

    void moveRight(int last)
    {    
        if(last == ui.achievementFrames.size()) 
        {
            return; 
        }

        x += minFrameSize;  
     }
}
