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
    private PImage achievementLockedOverlay; 

    AchievementImageFrame(int posX, int id)
    {
        Achievement achievement = achievementHelper.getAchievementData(id); 

        //Get the appropriate image for the achievement based on its rarity
        achievementImage = ResourceManager.getImage("Achievement" + achievement.rarity); 
        achievementLockedOverlay = ResourceManager.getImage("lockedAchievement"); 

        this.posX = posX; 
        position.x = width / 2 + ((minFrameSize + margin) * posX); 
        achievementId = id; 
    }

    void draw()
    {
        position.y = height / 2.75f; 
        position.x = width / 2 + ((minFrameSize + margin) * posX) + xOffset;

        fill(255);
        rectMode(CENTER);
        imageMode(CENTER);

        rect(position.x, position.y, minFrameSize + selectedSizeOffset, minFrameSize + selectedSizeOffset);
        image(achievementImage, position.x, position.y, minFrameSize + selectedSizeOffset, minFrameSize + selectedSizeOffset); 
        textSize(ui.ACHIEVEMENT_FONT_SIZE/1.5);       
        text(returnText, 200, height - 25); 

        rectMode(CORNER);
        imageMode(CORNER);
        
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
                tint(0, 160); 
                imageMode(CENTER); 
                image(achievementLockedOverlay, position.x, position.y, minFrameSize + selectedSizeOffset - 25, minFrameSize + selectedSizeOffset - 25); 
                imageMode(CORNER); 
                noTint();
            }          
        }   
        else
        {
            deflate();                                                                              
        }       
    } 

    // Increase the size of the center image frame   
    void inflate()
    {
        if(selectedSizeOffset >= maxGrowSize)
        {
            return; 
        }

        selectedSizeOffset += growSpeed; 
    }

    // And decrease the size of the non-center frames
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
