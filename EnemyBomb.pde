class EnemyBomb extends Enemy
{
	//Animation
	private AnimatedImage explosionSequence;
	private AnimatedImage walkSequence;
	private AnimatedImage airSequence;

	//Explosion vars
	private boolean isExploding = false;
	private float explosionTimer = timeInSeconds(2.5f);
	private float explosionSize = 200f;
	private final float MAX_EXPLOSION_DAMAGE = 15f;

	EnemyBomb(PVector spawnPos)
	{
		super(spawnPos);

		//Stats setup
		float timerDecreaseValue = 0.1f;
		explosionTimer -= increasePower(timerDecreaseValue);
		//Keep the explosiontimer above 1 second for balance reason
		if (explosionTimer < 1f)
		{
			explosionTimer = 1f;
		}
		float explosionIncreaseValue = 30;
		explosionSize += increasePower(explosionIncreaseValue);

		//Visual setup
		image = ResourceManager.getImage("BombWalk0");
		this.speed = 2.5f;
		animationSetup();
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
				load(new Explosion(this.position, this.explosionSize, MAX_EXPLOSION_DAMAGE, true));
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

		if (!isExploding & isGrounded)
		{//walk animation
			walkSequence.draw();
			walkSequence.flipSpriteHorizontal = this.flipSpriteHorizontal;
		}
		else if (!isExploding & !isGrounded)
		{//Fall animation
			airSequence.draw();
			airSequence.flipSpriteHorizontal = this.flipSpriteHorizontal;
		}
		else
		{//Explode animation
			explosionSequence.draw();
			explosionSequence.flipSpriteHorizontal = this.flipSpriteHorizontal;
		}
	}

	void attackingPlayer(Player player)
	{
		this.isExploding = true;
		//Flip the explosion animation if need be
		this.explosionSequence.flipSpriteHorizontal = this.flipSpriteHorizontal;
	}

	private void animationSetup()
	{
		int explodeSprites = 9, walkSprites = 2, airSprites = 1;
		int walkSpeed = 6, airSpeed = 1;
		explosionSequence = new AnimatedImage("BombExplosion", explodeSprites, explosionTimer / explodeSprites, position, size.x, flipSpriteHorizontal);
		walkSequence = new AnimatedImage("BombWalk", walkSprites, walkSpeed, position, size.x, flipSpriteHorizontal);
		airSequence = new AnimatedImage("BombAir", airSprites, airSpeed, position, size.x, flipSpriteHorizontal);
	}
}
