class EnemyShocker extends Enemy
{
	//Shocker values
	private float stunTime = timeInSeconds(1f);

	//Animation
	private AnimatedImage walkSequence;

	EnemyShocker(PVector spawnPos)
	{
		super(spawnPos);

		// Values setup
		float stunIncreaseValue = 0.1f;
		this.stunTime += increasePower(stunIncreaseValue);

		// Image setup
		image = ResourceManager.getImage("ShockerWalk0");
		animationSetup();
	}

	void draw()
	{
		//Do nothing while paused
		if (gamePaused)
		{
			return;
		}

		this.walkSequence.draw();
		this.walkSequence.flipSpriteHorizontal = this.flipSpriteHorizontal;
	}

	protected void attackingPlayer(Player player)
	{
		player.takeDamage(playerDamage);
		//Stun the player
		player.stunTimer = this.stunTime;
		//Delete this enemy so that the player won't get stuck in a endless loop
		delete(this);
	}

	//Set up the animation
	private void animationSetup()
	{
		//Animation variables
		int walkFrames = 2;
		int walkSpeed = 6;

		//Fill the animated images for this enemy
		walkSequence = new AnimatedImage("ShockerWalk", walkFrames, walkSpeed, position, size.x, flipSpriteHorizontal);
	}


}
