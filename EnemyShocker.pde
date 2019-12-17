class EnemyShocker extends Enemy
{
	//Normal time times 60 seconds
	private float stunTime = timeInSeconds(1f);

	EnemyShocker(PVector spawnPos)
	{
		super(spawnPos);

		image = ResourceManager.getImage("ShockEnemy");

		setupLightSource(this, 175f, 1f);
	}

	//Completely over the handleCollision function
	protected void handleCollision()
	{
		if (CollisionHelper.rectRect(position, size, player.position, player.size))
		{
			player.takeDamage(playerDamage);
			//Stun the player
			player.stunTimer = stunTime;
			//Delete this enemy so that the player won't get stick in a endless loop
			delete(this);
		}
	}
}
