public class AchievementHelper
{

    // 0 - Lone Digger (player has dug more than 100 tiles)
    // 1 - Combo Master (player got the largest posible)

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

    AchievementRarity getAchievementRarity(int id)
    {
        Achievement achievement = getAchievementData(id); 
        
        for(AchievementRarity rarity : allAchievementsRarity)
        {
            if(achievement.rarity == rarity.id)
            {
                return rarity; 
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

public class AchievementImageFrame
{
    public float minFrameSize = 150;
    public float maxGrowSize = 50;
    public float growSpeed = 3f;  
    public float selectedSizeOffset; 
    public String lockedAchievementText = "???"; 
    public boolean isSelected; 
    public float margin = 40f; 
    public float x; 
    public float y;
    private float xOffset; 
    private float rarityTextOffset = 100f; 
    public int achievementId; 
    private int posX; 
    private PImage achievementImage; 

    AchievementImageFrame(int posX, int id)
    {
        Achievement achievement = achievementHelper.getAchievementData(id); 

        achievementImage = ResourceManager.getImage("Achievement" + achievement.rarity); 
        this.posX = posX; 
        x = width/2 + ((minFrameSize + margin) * posX); 
        achievementId = id; 
    }

    void draw()
    {
        y = height/2.75f; 
        x = width/2 + ((minFrameSize + margin) * posX) + xOffset;
        
        // If the frame is the center one
        if(isSelected)
        {
            inflate();  
            fill(255);              
            textSize(ui.achievementUiSize);
            text(achievementHelper.getAchievementData(achievementId).name, width/2, height-200);
            text(achievementHelper.getAchievementRarity(achievementId).rarity, width/2, y + 150); 

            if(achievementHelper.hasUnlockedAchievement(achievementId))
            {
                text(achievementHelper.getAchievementData(achievementId).description, width/2, height-100);
            }
            else
            {
                text(lockedAchievementText, width/2, height-100); 
            }          
        }   
        else
        {
            deflate();
        }

        fill(255); 
        rectMode(CENTER); 
        imageMode(CENTER); 
        noStroke(); 
        rect(x, y, minFrameSize + selectedSizeOffset, minFrameSize + selectedSizeOffset); 
        image(achievementImage, x, y, minFrameSize + selectedSizeOffset, minFrameSize + selectedSizeOffset); 
        imageMode(CORNER); 
        rectMode(CORNER);         
    } 
       
    void inflate()
    {
        if(selectedSizeOffset >= maxGrowSize)
        {
            return; 
        }

        selectedSizeOffset += growSpeed; 
    }

    void deflate()
    {
        if(selectedSizeOffset <= 0)
        {
            return; 
        }

        selectedSizeOffset -= growSpeed;
    }

    void moveLeft()
    {    
        xOffset -= minFrameSize + margin;
    }

    void moveRight()
    {     
        xOffset += minFrameSize + margin;  
     }
}
