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
		this.speed = random(minSpeed += increasePower(speedIncreaseValue), maxSpeed += increasePower(speedIncreaseValue));

		//Choose randomly if we go left or right
		int direction = int(random(2));

		if (direction == 1)
		{//Go left if direction == 1
			walkLeft = true;
		}
	}

	void draw()
	{
		//Do nothing while paused
		if (gamePaused)
		{
			return;
		}

		//Draw float sprites
		this.floatSequence.draw();
		this.floatSequence.flipSpriteHorizontal = this.flipSpriteHorizontal;
	}

	//Set up the animation
	private void animationSetup()
	{
		//Animation variables
		int animationFrames = 4;
		int animationSpeed = 8;

		//Fill the animated images for this enemy
		floatSequence = new AnimatedImage("GhostEnemy", animationFrames, animationSpeed, position, size.x, flipSpriteHorizontal);
	}
}
