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
		if (attacking)
		{// Play attack animation
			attackSequence.draw();
		}
		else
		{// Draw idle sprite
			idleSequence.draw();
		}
	}

	private void animationSetup()
	{
		int attackFrames = 2, idleFrames = 1;
		int attackSpeed = 8, idleSpeed = 1;
		attackSequence = new AnimatedImage("MimicAttack", attackFrames, attackSpeed, position, size.x, flipSpriteHorizontal);
		idleSequence = new AnimatedImage("MimicIdle", idleFrames, idleSpeed, position, size.x, flipSpriteHorizontal);
	}

	protected void attackingPlayer(Player player)
	{
		attacking = true;
		player.takeDamage(playerDamage);
	}
}
