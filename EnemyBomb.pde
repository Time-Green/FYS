class EnemyBomb extends Enemy
{
	//Animation
	private AnimatedImage explosionSequence;
	private final int NUMBEROFSPRITES = 9;

	//Explosion vars
	private float detectionRange = 90f;
	private boolean isExploding = false;
	private float explosionTimer = 1.5f * 40f;
	private float explosionSize = 325f;
	private final float MAX_EXPLOSION_DAMAGE = 15f;

	EnemyBomb(PVector spawnPos)
	{
		super(spawnPos);

		image = ResourceManager.getImage("BombEnemy0");
		this.speed = 2.5f;

		explosionSequence = new AnimatedImage("BombEnemy", NUMBEROFSPRITES, explosionTimer / NUMBEROFSPRITES, position, size.x, !walkLeft);
	}

	void update()
	{
		super.update();

		if (isExploding)
		{
			this.speed = 0;
			//Decrease the explosion timer
			this.explosionTimer--;

			if (this.explosionTimer <= 0)
			{
				//Explode
				load(new Explosion(this.position, this.explosionSize, this.MAX_EXPLOSION_DAMAGE, true));
				delete(this);
			}
		}
	}

	void draw()
	{
		//Do nothing while paused
		if (gamePaused)
		{
			return;
		}

		//Normal animation
		if (!isExploding)
		{
			super.draw();
		}

		//Explode animation
		else
		{
			explosionSequence.draw();
		}
	}

	protected void handleCollision()
	{
		super.handleCollision();

		//Activate the explosion sequence when the player gets too close
		if (CollisionHelper.rectRect(position, new PVector(size.x + detectionRange, size.y + detectionRange), player.position, player.size) && isExploding == false)
		{
			this.isExploding = true;
			//Flip the explosion animation if need be
			this.explosionSequence.flipSpriteHorizontal = this.flipSpriteHorizontal;
		}
	}
}
