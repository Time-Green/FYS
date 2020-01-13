class EnemyGhost extends Enemy
{
	// Animation
	private AnimatedImage floatSequence;

	EnemyGhost(PVector spawnPos)
	{
		super(spawnPos);
		setMaxHp(1000);

		//Visual setup
		image = ResourceManager.getImage("GhostEnemy0");
		
		drawLayer = PRIORITY_LAYER;
		animationSetup();

		//Movement setup
		collisionEnabled = false;
		gravityForce = 0;

		//Speed setup
		float minSpeed = 1f;
		float maxSpeed = 5f;
		float speedIncreaseValue = 0.5f;
		speed = random(minSpeed += increasePower(speedIncreaseValue), maxSpeed += increasePower(speedIncreaseValue));

		//Choose randomly if we go left or right
		int direction = int(random(2));

		if (direction == 1)
		{
			walkLeft = true;
		}
	}

	void draw()
	{
		floatSequence.draw();
		floatSequence.flipSpriteHorizontal = this.flipSpriteHorizontal;
	}

	private void animationSetup()
	{
		int animationFrames = 4;
		int animationSpeed = 8;
		floatSequence = new AnimatedImage("GhostEnemy", animationFrames, animationSpeed, position, size.x, flipSpriteHorizontal);
	}
}
