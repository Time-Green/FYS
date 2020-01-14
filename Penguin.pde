class Penguin extends Enemy
{
	Penguin(PVector spawnPos)
	{
		super(spawnPos);
        playerDamage = 2f;

		//Image setup
		image = ResourceManager.getImage("Penguin");

		float speedIncreaseValue = 0.2f;
		speed = (defaultSpeed += increasePower(speedIncreaseValue));
	}

	// void wiggleSound()
	// {
	// 	if(isMiningLeft == true || isMiningRight == true)
	// 	{
	// 		for (int i = 1; i < 5; i++)
	// 		{
	// 			AudioManager.playSoundEffect("PenguinFootStep" + i);
	// 		}
	// 	}
	// }

	void dig()
	{
		if (timesCollided >= MAX_COLLISIONS) 
		{
			timeLeftToDig = digTimer;

			if (timeLeftToDig > 0) 
			{
				timeLeftToDig -= TimeManager.deltaFix;
				isMiningLeft = true;
				isMiningRight = true;
			}
			else 
			{
				isMiningLeft = false;
				isMiningRight = false;
				timesCollided = 0;				
			}
		}
	}
}
