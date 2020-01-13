class Enemy extends Mob
{
	//Health
	protected float defaultHealth = 10;

	//Damage
	protected float playerDamage = 10f;

	//Digging
	protected float digTimer = timeInSeconds(5f);
	protected float timeLeftToDig = 0;

	//Movememt
	protected float defaultSpeed = 5f;
	protected float distanceFromBorders = 10f;

	//Light
	protected float defaultLight = 125f;

	public Enemy(PVector spawnPos)
	{
		this.speed = defaultSpeed;

		setMaxHp(defaultHealth);
		setupLightSource(this, defaultLight, 1f);

		this.position.set(spawnPos);
		this.velocity.set(-speed, 0);
	}

	//Add this enemt to the mob list
	void specialAdd()
	{
		super.specialAdd();
		mobList.add(this);
	}

	//Remove the enemy
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
		if (this.walkLeft == true)
		{//Go left
			this.velocity.x = -speed;

			//Flip the image
			this.flipSpriteHorizontal = false;
		}
		else
		{//Go right
			this.velocity.x = speed;

			//Flip the image
			this.flipSpriteHorizontal = true;
		}

		//Stop the enemies from walking outside the screen
		if (position.x < distanceFromBorders)
		{
			walkLeft = false;
		}

		if (position.x > world.getWidth() - distanceFromBorders)
		{
			walkLeft = true;
		}

		dig();
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

	protected void dig()
	{
		if (timesCollided >= MAX_COLLISIONS) 
		{//Has this enemy collider to much with the environment
			timeLeftToDig = digTimer;

			//Start the timer
			if (timeLeftToDig > 0) 
			{//Start digging like crazy
				timeLeftToDig -= TimeManager.deltaFix;
				isMiningDown = true;
				isMiningUp = true;
				isMiningLeft = true;
				isMiningRight = true;
			}
			else 
			{//STOP
				isMiningDown = false;
				isMiningUp = false;
				isMiningLeft = false;
				isMiningRight = false;
				timesCollided = 0;				
			}
		}
	}
}
