class Mob extends Movable
{
	//Health
	float maxHealth = 30;
	float currentHealth = maxHealth;
	boolean isImmortal = false;

	//Movement
	protected boolean isSwimming = false;
	protected boolean canSwim = false; 

	//Taking damage
	protected final float HURTCOOLDOWN = timeInSeconds(1f);
	protected float timeSinceLastHurt = 0f; 
	protected boolean isHurt;

	//Mining
	protected float miningCooldown = timeInSeconds(.1f); //cooldown in millis
	protected float lastMine;
	protected float baseDamage = 1;

	//Inventory
	protected int maxInventory = 2;
	protected int lastUse;
	protected int useCooldown = 100;

	//regen and fire
	public float regen = 0.05f;
	private final float fireDamage = 8;
	private final float iceDamage = 4;

	public boolean canRegen = false;
	public boolean isOnFire = false;
	public boolean isChilled = false;
	public boolean isDark = false;
	private float fireTimer;
	private float regenTimer;
	private float chilledTimer;
	private float darkTimer;

	Mob()
	{
		super();
		drawLayer = MOB_LAYER;
	}

	public void update()
	{
		super.update();

		handleOnFire();

		handleDark();

		regenaration();

		if (canSwim)
		{
			if (isSwimming)
			{
				gravityForce = 0.1f;
			}
			else
			{
				gravityForce = 1;
			}
		}

		if (isHurt == true)
		{
			//Count up until we can be hurt again
			timeSinceLastHurt += TimeManager.deltaFix;

			if (timeSinceLastHurt >= HURTCOOLDOWN)
			{
				timeSinceLastHurt = 0;
				isHurt = false;
			}
		}
	}

	public void attemptMine(BaseObject object)
	{

		// In the overworld we disable digging all together. 
		if (gameState == GameState.Overworld)
		{
			return;
		}
		else
		{
			//ask the tile if they wanna be mined first
			if (!object.canMine())
			{
				return;
			}

			//simple cooldown check
			if (millis() < lastMine + miningCooldown)
			{
				return;
			}

			object.takeDamage(getAttackPower()); 

			lastMine = millis();
			afterMine(object);
		}
	}

	// hook, used by player to count the mined tiles
	protected void afterMine(BaseObject object)
	{
		return;
	}

	public void takeDamage(float damageTaken)
	{
		super.takeDamage(damageTaken);

		if (isImmortal)
		{
			return;
		}
		else
		{
			if (isHurt == false)
			{
				isHurt = true;
				currentHealth -= damageTaken;
				regenTimer = 0;

				if (currentHealth <= 0)
				{
					die();
				}
			}
		}
	}

	protected void die()
	{

	}

	float getAttackPower()
	{

		return baseDamage;
	}

		//fire damage blocks regenaration
	public void handleOnFire()
	{
		if(isOnFire)
		{
			if(floor(fireTimer) % 20 == 0)
			{
				takeDamage(fireDamage);

				if(fireTimer > 180)
				{
					isOnFire = false;
				}
			}
			
			fireTimer += TimeManager.deltaFix;
		}
	}

		public void setChilled()
	{
		if(isChilled)
		{
			if(floor(chilledTimer) % 90 == 0)
			{
				takeDamage(iceDamage);
				player.baseDamage = baseDamage * 0.5f;
				player.speed = speed * 0.5f;

				if(chilledTimer > 480)
				{
					isChilled = false;
				}
			}
			
			chilledTimer += TimeManager.deltaFix;
		}
	}

	public void handleDark()
	{
		if(isDark)
		{
			if(darkTimer > 480)
			{
				isDark = false;
			}
		}
			
		darkTimer += TimeManager.deltaFix;
	}

	void regenaration()
	{
		if(regenTimer > 120)
		{
			if(currentHealth < maxHealth)
			{
				currentHealth += regen * TimeManager.deltaFix;

				if(this == player && currentHealth >= maxHealth / 5f)
				{
					ui.drawWarningOverlay = false;
				}
			}
		}

		regenTimer += TimeManager.deltaFix;
	}

	void setOnFire()
	{
		isOnFire = true;
		fireTimer = 0;
	}

	void removeLight()
	{
		isDark = true;
		darkTimer = 0;
	}

	void setMaxHp(float hpToSet)
	{
		maxHealth = hpToSet;
		currentHealth = maxHealth;
	}

	public boolean canPickup(Pickup Pickup)
	{
		return false;
	}
}
