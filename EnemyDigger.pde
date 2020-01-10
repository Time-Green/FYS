class EnemyDigger extends Enemy
{
	// Chase vars
	private float chaseDistance;
	private final float IDLE_SPEED = 0f;
	private float chaseSpeed = 2f;
	private boolean isChasing;

	// Animation
	private AnimatedImage digSequence;

	EnemyDigger(PVector spawnPos)
	{
		super(spawnPos);

		chaseSpeed += 0.25f *getDepth()/100;
		setUpAnimation();

		image = ResourceManager.getImage("DiggerEnemyIdle");
		this.speed = IDLE_SPEED;

		float tileDistance = 10f;
		chaseDistance = OBJECTSIZE * tileDistance;
		// this.flipSpriteVertical = true;
	}

	void draw()
	{
		if (!isChasing) //Normal animation
		{
			super.draw();
		}
		else //Chase animation
		{
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
			{
				this.walkLeft = true;//GO left
			}
			else
			{
				this.walkLeft = false;//Go right
			}

			if (this.position.y < playerY)
			{
				this.gravityForce = chaseSpeed/2;//Go down
				this.flipSpriteVertical = true;
			}
			else
			{
				this.gravityForce = -chaseSpeed;//Go up
				this.flipSpriteVertical = false;
			}
			
			//Allow us to mine
			this.isMiningLeft = true;
			this.isMiningRight = true;
			this.isMiningDown = true;
			this.isMiningUp = true;

		}
		else
		{
			//Don't chase the player
			this.speed = IDLE_SPEED;
			this.isMiningLeft = false;
			this.isMiningRight = false;
			this.isMiningUp = false;
			this.isMiningDown = false;
			this.gravityForce = 0;
			this.isChasing = false;
		}

	}

	private void setUpAnimation()
	{
		int digFrames = 3;
		int digAnimSpeed = 8;
		digSequence = new AnimatedImage("DiggerEnemyDigging", digFrames, digAnimSpeed, position, size.x, size.y, flipSpriteHorizontal, flipSpriteVertical);
	}
}
