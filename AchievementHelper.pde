public class AchievementHelper
{

    

    void unlock(int id)
    {   
        println("Player unlocked: "+ getAchievementData(id).name);
        runData.unlockedAchievementIds.add(id); 
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
}
