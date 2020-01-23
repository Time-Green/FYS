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
		this.speed = (defaultSpeed += increasePower(speedIncreaseValue));
	}

	void draw()
	{
		//Do nothing while paused
		if (gamePaused)
		{
			return;
		}

		if (this.timeLeftToDig <= 0)
		{//This enemy is not digging
			if (this.isGrounded)
			{//Walk animation
				this.walkSequence.draw();
				this.walkSequence.flipSpriteHorizontal = this.flipSpriteHorizontal;
			}
			else
			{//Air animation
				this.airSequence.draw();
				this.airSequence.flipSpriteHorizontal = this.flipSpriteHorizontal;
			}
		}
		else
		{//This enemy is digging
			//Dig animation
			this.digSequence.draw();
			this.digSequence.flipSpriteHorizontal = this.flipSpriteHorizontal;
		}

	}

	//Set up the animation
	private void animationSetup()
	{
		//Animation variables
		int walkFrames = 4, airFrames = 2, digFrames = 3;
		int walkSpeed = 6, airSpeed = 4, digSpeed = 4;

		//Fill the animated images for this enemy
		walkSequence = new AnimatedImage("WalkerWalk", walkFrames, walkSpeed, position, size.x, flipSpriteHorizontal);
		airSequence = new AnimatedImage("WalkerAir", airFrames, airSpeed, position, size.x, flipSpriteHorizontal);
		digSequence = new AnimatedImage("WalkerDigging", digFrames, digSpeed, position, size.x, flipSpriteHorizontal);
	}
}
