class Penguin extends Enemy
{

	Penguin(PVector spawnPos)
	{
		super(spawnPos);
        playerDamage = 2f;

		//Image setup
		image = ResourceManager.getImage("Penguin");

		float speedIncreaseValue = 0.3f;
		speed = (defaultSpeed += increasePower(speedIncreaseValue));
	}
}
