class EnemyDigger extends Enemy
{
	// Chase vars
	private float chaseDistance;
	private final float IDLE_SPEED = 0f;
	private float chaseSpeed = 3f;
	private boolean isChasing;

	// Animation
	private AnimatedImage digSequence;

	EnemyDigger(PVector spawnPos)
	{
		super(spawnPos);

		//Images
		image = ResourceManager.getImage("DiggerIdle");
		animationSetup();

		//Setup chase vars
		float chaseSpeedIncreaseValue = 0.25f;
		chaseSpeed += increasePower(chaseSpeedIncreaseValue);
		//Determine how many tiles we want the Digger to chase the player
		float tileChaseDistance = 20f;
		chaseDistance = OBJECT_SIZE * tileChaseDistance;
		this.speed = IDLE_SPEED;

		//Allow this enemy to mine
		this.isMiningLeft = true;
		this.isMiningRight = true;
		this.isMiningDown = true;
		this.isMiningUp = true;
		this.gravityForce = 0;
	}

	void draw()
	{
		//Do nothing while paused
		if (gamePaused)
		{
			return;
		}
		
		if (!isChasing)
		{//Normal animation
			super.draw();
		}
		else
		{//Chase animation
			digSequence.draw();
			digSequence.flipSpriteVertical = flipSpriteVertical;
		}
		
	}

	void update()
	{
		super.update();

		float distanceToPlayer = dist(this.position.x, this.position.y, player.position.x, player.position.y);

		if (distanceToPlayer <= chaseDistance)
		{
			float playerX = player.position.x;
			float playerY = player.position.y;

			//Chase the player
			this.speed = chaseSpeed;
			this.isChasing = true;

			if (this.position.x > playerX)
			{//GO left
				this.walkLeft = true;
			}
			else
			{//Go right
				this.walkLeft = false;
			}

			if (this.position.y < playerY)
			{//Go down
				this.velocity.y = chaseSpeed;
				this.flipSpriteVertical = true;
			}
			else
			{//Go up
				this.velocity.y = -chaseSpeed;
				this.flipSpriteVertical = false;
			}

		}
		else
		{//Don't chase the player
			this.speed = IDLE_SPEED;	
			this.isChasing = false;
		}

	}

	private void animationSetup()
	{
		int digFrames = 3;
		int digAnimSpeed = 8;
		digSequence = new AnimatedImage("DiggerDigging", digFrames, digAnimSpeed, position, size.x, size.y, flipSpriteHorizontal, flipSpriteVertical);
	}
}
