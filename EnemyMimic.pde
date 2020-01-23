class EnemyMimic extends Enemy
{
	//Mimic vars
	private boolean attacking;

	//Animation
	private AnimatedImage idleSequence;
	private AnimatedImage attackSequence;

	EnemyMimic(PVector spawnPos)
	{
		//Start off pretending we are a chest
		super(spawnPos);
		image = ResourceManager.getImage("MimicIdle0");
		this.speed = 0;
		animationSetup();
	}

	void draw()
	{
		//Do nothing while paused
		if (gamePaused)
		{
			return;
		}
		
		if (this.attacking)
		{// Play attack animation
			attackSequence.draw();
		}
		else
		{// Draw idle sprite
			idleSequence.draw();
		}
	}

	//Set up the animation
	private void animationSetup()
	{
		//Animation variables
		int attackFrames = 2, idleFrames = 1;
		int attackSpeed = 8, idleSpeed = 1;

		//Fill the animated images for this enemy
		attackSequence = new AnimatedImage("MimicAttack", attackFrames, attackSpeed, position, size.x, flipSpriteHorizontal);
		idleSequence = new AnimatedImage("MimicIdle", idleFrames, idleSpeed, position, size.x, flipSpriteHorizontal);
	}

	protected void attackingPlayer(Player player)
	{
		//Set this enemy to the attacking state
		this.attacking = true;
		player.takeDamage(playerDamage);
	}
}
