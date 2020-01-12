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
			this.explosionTimer -= TimeManager.deltaFix;

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
		final int EXPLODE_SPRITES = 9, WALK_SPRITES = 2, AIR_SPRITES = 1;
		final int WALK_SPEED = 6, AIR_SPEED = 1;

		explosionSequence = new AnimatedImage("BombExplosion", EXPLODE_SPRITES, explosionTimer / EXPLODE_SPRITES, position, size.x, flipSpriteHorizontal);
		walkSequence = new AnimatedImage("BombWalk", WALK_SPRITES, WALK_SPEED, position, size.x, flipSpriteHorizontal);
		airSequence = new AnimatedImage("BombAir", AIR_SPRITES, AIR_SPEED, position, size.x, flipSpriteHorizontal);
	}
}
