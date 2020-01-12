public class AchievementImageFrame
{
    public float minFrameSize = 150;
    public float maxGrowSize = 50;
    public float growSpeed = 3f;  
    public float selectedSizeOffset; 
    public String lockedAchievementText = "???"; 
    public String returnText = "Press start to go back"; 
    public boolean isSelected; 
    public float margin = 40f; 
    private PVector position = new PVector();
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
        position.x = width / 2 + ((minFrameSize + margin) * posX); 
        achievementId = id; 
    }

    void draw()
    {
        position.y = height / 2.75f; 
        position.x = width / 2 + ((minFrameSize + margin) * posX) + xOffset;
        
        // If the frame is the center one
        if(isSelected)
        {
            inflate();  

            fill(255);              
            textSize(ui.ACHIEVEMENT_FONT_SIZE);

            text(achievementHelper.getAchievementData(achievementId).name, width / 2, height - 200);
            text(achievementHelper.getAchievementRarity(achievementId).rarity, width / 2, position.y + 150); 

            if(achievementHelper.hasUnlockedAchievement(achievementId))
            {
                textSize(ui.ACHIEVEMENT_FONT_SIZE/1.2);
                text(achievementHelper.getAchievementData(achievementId).description, width / 2, height - 100);
                textSize(ui.ACHIEVEMENT_FONT_SIZE);
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

        rect(position.x, position.y, minFrameSize + selectedSizeOffset, minFrameSize + selectedSizeOffset);
        image(achievementImage, position.x, position.y, minFrameSize + selectedSizeOffset, minFrameSize + selectedSizeOffset); 
        textSize(ui.ACHIEVEMENT_FONT_SIZE/1.5);       
        text(returnText, 200, height - 25); 

        rectMode(CORNER);
        imageMode(CORNER);
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
