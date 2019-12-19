class EnemyGhost extends Enemy
{
	EnemyGhost(PVector spawnPos)
	{
		super(spawnPos);

		image = ResourceManager.getImage("GhostEnemy2");
		setupLightSource(this, 125f, 1f);
		setMaxHp(1000);

		speed = random(2.5f, 7.5f);

		//Choose a random move direction
		int direction = int(random(2));
		
		if (direction == 1)
		{
			walkLeft = true;
		}

		//Disable gravity and collsion so that this enemy acts like a ghost
		collisionEnabled = false;
		gravityForce = 0;
		canSwim = false;
	}

	void update()
	{
		super.update();

		flipSpriteHorizontal = velocity.x > 0;
	}
}
