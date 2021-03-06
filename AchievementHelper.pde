public class AchievementHelper
{

    // 0 - Lone Digger (player has dug more than 100 tiles)
    // 1 - Combo Master (player got the largest posible combo)
    // 2 - Persistence (You have reached a depth of 1000 meters!)
    // 3 - Greed is good (Accumulate over 100.000 points in a single run!) 
    // 4 - Hard as a rock (You managed to dig 500 meters without taking damage, Impressive!)
    // 5 - michael bay approves (You destroyed 20 explosive tiles, kaboom!) 

    void unlock(int id)
    {                                                                                       
        // when we are not connected to the database, we cant unlock achievements
        if(databaseManager.currentSessionId == -1)
        {
            return;
        }

        if(achievementExists(id))
        {
             println("Player " + dbUser.userName + " has unlocked: " + getAchievementData(id).name);
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
