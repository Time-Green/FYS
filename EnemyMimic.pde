class EnemyMimic extends Enemy
{
	private boolean detected;

	EnemyMimic(PVector spawnPos)
	{
		//Start off pretending we are a block
		super(spawnPos);
		image = ResourceManager.getImage("MimicTile");
		this.speed = 0;
		gravityForce = 0;
	}

	void update()
	{
		super.update();

		//The jig is up
		if (detected)
		{
			//Act like a normal enemy
			final float NORMALSPEED = 6f;
			this.speed = NORMALSPEED;
			gravityForce = 1;
			image = ResourceManager.getImage("MimicEnemy");
		}
	}

	protected void handleCollision()
	{
		super.handleCollision();

		if (CollisionHelper.rectRect(position, size, player.position, player.size))
		{
			detected = true;
		}
	}
}
