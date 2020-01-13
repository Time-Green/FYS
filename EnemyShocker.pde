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
		stunTime += increasePower(stunIncreaseValue);

		// Image setup
		image = ResourceManager.getImage("ShockerWalk0");
		animationSetup();
	}

	void draw()
	{
		walkSequence.draw();
		walkSequence.flipSpriteHorizontal = this.flipSpriteHorizontal;
	}

	protected void attackingPlayer(Player player)
	{
		player.takeDamage(playerDamage);
		//Stun the player
		player.stunTimer = stunTime;
		//Delete this enemy so that the player won't get stuck in a endless loop
		delete(this);
	}

	private void animationSetup()
	{
		int walkFrames = 2;
		int walkSpeed = 6;
		walkSequence = new AnimatedImage("ShockerWalk", walkFrames, walkSpeed, position, size.x, flipSpriteHorizontal);
	}


}
