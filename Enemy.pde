class Enemy extends Mob
{
	//Damage
	protected float playerDamage = 10f;

	//Digging
	protected float digTimer = timeInSeconds(5f);
	protected float timeLeftToDig;

	public Enemy(PVector spawnPos)
	{
		this.speed = 5f;

		setMaxHp(10);

		this.position.set(spawnPos);
		this.velocity.set(-speed, 0);

	}

	void specialAdd()
	{
		super.specialAdd();
		mobList.add(this);
	}

	void destroyed()
	{
		super.destroyed();
		mobList.remove(this);
	}

	void update()
	{
		if (gamePaused)
		{
			return;
		}

		super.update();

		handleCollision();

		movement();

		//Dying
		if (currentHealth <= 0)
		{
			delete(this);
		}
			
	}

	protected void movement() {
		//Can you guys please stop removing this bool from this script please?
		if (this.walkLeft == true)
		{
			this.velocity.set(-speed, 0);

			//Flip the image
			this.flipSpriteHorizontal = false;
		}
		else
		{
			this.velocity.set(speed, 0);

			//Flip the image
			this.flipSpriteHorizontal = true;
		}

		//Stop the enemies from walking outside the screen
		if (position.x < 10)
		{
			walkLeft = false;
		}

		if (position.x > world.getWidth() - 10)
		{
			walkLeft = true;
		}

		if (timesCollided >= MAXCOLLISIONS) 
		{
			timeLeftToDig = digTimer;
			if (timeLeftToDig > 0) 
			{
				timeLeftToDig--;
				isMiningDown = true;
				isMiningUp = true;
				isMiningLeft = true;
				isMiningRight = true;
			}
			else 
			{
				isMiningDown = false;
				isMiningUp = false;
				isMiningLeft = false;
				isMiningRight = false;
				timesCollided = 0;				
			}
		}
	}
	

	protected void handleCollision()
	{
		if (CollisionHelper.rectRect(position, size, player.position, player.size))
		{
			player.takeDamage(playerDamage);
		}
	}
}
