class Enemy extends Mob
{
	//Damage
	protected float playerDamage = 10f;

	//Digging
	protected float digTimer = timeInSeconds(5f);
	protected float timeLeftToDig = 0;

	//Movememt
	protected float defaultSpeed = 5f;

	public Enemy(PVector spawnPos)
	{
		this.speed = defaultSpeed;

		setMaxHp(10);
		setupLightSource(this, 125f, 1f);

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

		movement();

		//Dying
		if (currentHealth <= 0)
		{
			delete(this);
		}	
	}

	protected void movement()
	{
		//Can you guys please stop removing this bool from this script please?
		if (this.walkLeft == true)
		{
			this.velocity.x = -speed;

			//Flip the image
			this.flipSpriteHorizontal = false;
		}
		else
		{
			this.velocity.x = speed;

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

		if (timesCollided >= MAX_COLLISIONS) 
		{
			timeLeftToDig = digTimer;

			if (timeLeftToDig > 0) 
			{
				timeLeftToDig -= TimeManager.deltaFix;
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

	boolean canCollideWith(BaseObject object) 
	{
		if(object.canPlayerInteract())
		{
			attackingPlayer((Player) object);
		}
		//we phase through the player so we need to put this here, because we dont collide

		return super.canCollideWith(object);
	}

	protected void attackingPlayer(Player player)
	{
		player.takeDamage(playerDamage);
	}

	protected float increasePower(float variable)
	{
		//Increase thet power of the varabile for each 100 the player had dug
		variable *= getDepth()/100;
		return variable;
	}
}
