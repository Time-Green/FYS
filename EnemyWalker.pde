class EnemyWalker extends Enemy
{
	//Animation
	private AnimatedImage walkSequence;
	private AnimatedImage airSequence;
	private AnimatedImage digSequence;

	EnemyWalker(PVector spawnPos)
	{
		super(spawnPos);

		//Image setup
		image = ResourceManager.getImage("DiggerIdle");
		animationSetup();

		float speedIncreaseValue = 0.5f;
		speed = (defaultSpeed += increasePower(speedIncreaseValue));
	}

	void draw()
	{
		//Do nothing while paused
		if (gamePaused)
		{
			return;
		}

		if (timeLeftToDig <= 0)
		{
			if (isGrounded)
			{//Walk animation
				walkSequence.draw();
				walkSequence.flipSpriteHorizontal = this.flipSpriteHorizontal;
			}
			else
			{//Air animation
				airSequence.draw();
				airSequence.flipSpriteHorizontal = this.flipSpriteHorizontal;
			}
		}
		else
		{//Dig animation
			digSequence.draw();
			digSequence.flipSpriteHorizontal = this.flipSpriteHorizontal;
		}

	}


	private void animationSetup()
	{
		int walkFrames = 4, airFrames = 2, digFrames = 3;
		int walkSpeed = 6, airSpeed = 4, digSpeed = 4;
		walkSequence = new AnimatedImage("WalkerWalk", walkFrames, walkSpeed, position, size.x, flipSpriteHorizontal);
		airSequence = new AnimatedImage("WalkerAir", airFrames, airSpeed, position, size.x, flipSpriteHorizontal);
		digSequence = new AnimatedImage("WalkerDigging", digFrames, digSpeed, position, size.x, flipSpriteHorizontal);
	}
}
