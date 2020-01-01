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
	//we use an array here, because position matters and arraylist will shift it
	protected Item[] inventory = new Item[maxInventory];
	protected boolean[] inventoryDrawable = new boolean[maxInventory]; //set to false on specific location to stop drawing, like the homing item thing

	//regen and fire
	public float regen = 0.05f;
	private final float fireDamage = 8;
	public boolean canRegen = false;
	public boolean isOnFire = false;
	private int fireTimer;
	private int regenTimer;

	Mob()
	{
		super();
		drawLayer = MOB_LAYER;
	}

	public void update()
	{
		super.update();

		handleOnFire();

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
			timeSinceLastHurt++;

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
		if (currentGameState == GameState.Overworld)
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

	public void die()
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
			if(fireTimer % 20 == 0)
			{
				takeDamage(fireDamage);

				if(fireTimer > 180)
				{
					isOnFire = false;
				}
			}
			
			fireTimer++;
		}
	}

	void regenaration()
	{
		if(regenTimer > 120)
		{
			if(currentHealth < maxHealth)
			{
				currentHealth += regen;

				if(this == player && currentHealth >= maxHealth / 5f)
				{
					ui.drawWarningOverlay = false;
				}
			}
		}

		regenTimer++;
	}

	void setOnFire()
	{
		isOnFire = true;
		fireTimer = 0;
	}

	void setMaxHp(float hpToSet)
	{
		maxHealth = hpToSet;
		currentHealth = maxHealth;
	}

	boolean canPickup(Pickup Pickup)
	{
		return false;
	}

	boolean canAddToInventory(Item item)
	{
		for(int i = 0; i < inventory.length; i++)
		{
			if(inventory[i] == item) //cant have the same item in both hands
			{
				return false;
			}
		}

		for(int i = 0; i < inventory.length; i++)
		{
			if(inventory[i] == null) //cant have the same item in both hands
			{
				return true;
			}
		}
		return false;
	}

	void addToInventory(Item item)
	{
		item.suspended = true;
		load(new ItemParticleSystem(new PVector().set(position), 1, item));

		for(int i = 0; i < inventory.length; i++)
			{
				if(inventory[i] == null)
				{
					inventory[i] = item;
					inventoryDrawable[i] = false; //we set this to true again once the homing particle hits
					break;
				}
			}
	}

	void useInventory(int slot)
	{
		if (lastUse + useCooldown < millis() && inventory[slot] != null)
		{
			Item item = inventory[slot];

			item.onUse(this);
			item.suspended = false;

			lastUse = millis();
		}
	}

	void removeFromInventory(Item item)
	{
		for(int i = 0; i < inventory.length; i++)
		{
			if(inventory[i] == item)
			{
				inventory[i] = null;
			}
		}
	}

	int getFirstEmptyInventorySlot()
	{
		for(int i = 0; i < inventory.length; i++)
		{
			if(inventory[i] == null)
			{
				return i;
			}
		}

		return 0;
	}
}
