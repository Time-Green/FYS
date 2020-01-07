class Player extends Mob
{
	//Animation
	private AnimatedImage walkCycle;
	private AnimatedImage animatedImageIdle;
	private AnimatedImage animatedImageAir;
	private AnimatedImage animatedImageShocked;
	private AnimatedImage animatedImageMine;
	private AnimatedImage animatedImageFall;
	private AnimatedImage animatedImageFire;

	//Camera
	private float viewAmount = 400;
	private float viewTarget = viewAmount;
	private float easing = 0.025f;

	//Status effects
	public float stunTimer;
	public float shieldTimer;
	public float magnetTimer;

	boolean gotbonus1;
	private Shield myShield;

	private PVector spawnPosition = new PVector(1300, 509);
	public int score = 0;

	public Player()
	{
		position = spawnPosition;
		setMaxHp(100);
		baseDamage = 1.4;
		canRegen = true;
		jumpForce = 21f;
		drawLayer = PLAYER_LAYER;

		setUpAnimation();

		setupLightSource(this, viewAmount, 1f);

		applyRelicBoost();

		myShield = new Shield();
	}

	void update()
	{
		if (gamePaused)
		{  
			return;
		}

		super.update();

		if(player.getDepth() - OVERWORLD_HEIGHT > 100 && !achievementHelper.hasUnlockedAchievement(LONE_DIGGER_ACHIEVEMENT))
		{
			achievementHelper.unlock(LONE_DIGGER_ACHIEVEMENT); 
		}

		setVisibilityBasedOnCurrentBiome();

		checkHealthLow();

		statusEffects();

		digBonuses();

		if (stunTimer <= 0)
		{
			doPlayerMovement();
		}
	}

	void checkHealthLow()
	{
		// if lower than 20% health, show low health overlay
		if (currentHealth < maxHealth / 5f)
		{
			ui.drawWarningOverlay = true;

			if (frameCount % 60 == 0)
			{
				AudioManager.playSoundEffect("LowHealth");
			}
		}
	}

	void applyRelicBoost()
	{
		for(PlayerRelicInventory collectedRelicShardInventory : totalCollectedRelicShards)
		{
			if(collectedRelicShardInventory.relicshardid == 0)
			{
				baseDamage += DAMAGE_BOOST * getRelicStrength(collectedRelicShardInventory.amount);
			}
			else if(collectedRelicShardInventory.relicshardid == 1)
			{
				maxHealth += HEALTH_BOOST * getRelicStrength(collectedRelicShardInventory.amount);
				currentHealth += HEALTH_BOOST * getRelicStrength(collectedRelicShardInventory.amount);
			}
			else if(collectedRelicShardInventory.relicshardid == 2)
			{
				regen += REGEN_BOOST * getRelicStrength(collectedRelicShardInventory.amount);
			}
			else if(collectedRelicShardInventory.relicshardid == 3)
			{
				this.speed += SPEED_BOOST * getRelicStrength(collectedRelicShardInventory.amount);
			}
			else if(collectedRelicShardInventory.relicshardid == 4)
			{
				viewAmount += LIGHT_BOOST * getRelicStrength(collectedRelicShardInventory.amount);
			}
		}
	}

	float getRelicStrength(float relicAmount)
	{
		return floor(relicAmount/5);
	}

	void setVisibilityBasedOnCurrentBiome()
	{
		if (getDepth() > world.currentBiome.startedAt)
		{
			viewTarget = viewAmount * world.currentBiome.playerVisibilityScale;
		}

		float dy = viewTarget - lightEmitAmount;
		lightEmitAmount += dy * easing;
	}

	void draw()
	{
		if(gameState == GameState.GameOver)
		{
			// dont draw when we are dead
			return;
		}

		if(gamePaused)
		{
			animatedImageIdle.flipSpriteHorizontal = flipSpriteHorizontal;
			animatedImageIdle.draw();

			return;
		}

		handleAnimation();

		// player only, because we'll never bother adding a holding sprite for every mob 
		for (int i = 0; i < inventory.length; i++)
		{
			if(inventory[i] != null)
			{
				inventory[i].drawOnPlayer(this);
			}
		}
	}

	private void setUpAnimation()
	{
		//Movement animation
		int walkFrames = 4, idleFrames = 3, mineFrames = 3;
		int walkAnimSpeed = 8, idleAnimSpeed = 1, mineAnimSpeed = 5;
		walkCycle = new AnimatedImage("PlayerWalk", walkFrames, walkAnimSpeed, position, size.x, flipSpriteHorizontal);
		animatedImageIdle = new AnimatedImage("PlayerIdle", idleFrames, idleAnimSpeed, position, size.x, flipSpriteHorizontal);
		animatedImageMine = new AnimatedImage("PlayerMine", mineFrames, mineAnimSpeed, position, size.x, flipSpriteHorizontal);
		
		//Jumping animation
		int airFrames = 3, fallFrames = 4;
		int airAnimSpeed = 10, fallAnimSpeed = 20;
		animatedImageAir = new AnimatedImage("PlayerAir", airFrames, airAnimSpeed, position, size.x, flipSpriteHorizontal);
    	animatedImageFall = new AnimatedImage("PlayerFall", fallFrames, fallAnimSpeed, position, size.x, flipSpriteHorizontal);

		//Status effects
		int shockFrames = 2, fireFrames = 4;
		int statusEffectAnimSpeed = 10;
		animatedImageShocked = new AnimatedImage("PlayerShock", shockFrames, statusEffectAnimSpeed, position, size.x, flipSpriteHorizontal);
		animatedImageFire = new AnimatedImage("FireP", fireFrames, statusEffectAnimSpeed, position, size.x, flipSpriteHorizontal);
	}

	private void handleAnimation()
	{
		if(isOnFire == true)
		{
			tint(255, 200);
			animatedImageFire.flipSpriteHorizontal = flipSpriteHorizontal;
			animatedImageFire.draw();

			AudioManager.playSoundEffect("FireSound");
		}

		// Am I stunned?
		if (stunTimer > 0f)
		{
			animatedImageShocked.flipSpriteHorizontal = flipSpriteHorizontal;
			animatedImageShocked.draw();
		}
		else // Play the other animations when we are not stunned
		{
			if ((InputHelper.isKeyDown(LEFT_KEY) || InputHelper.isKeyDown(RIGHT_KEY)) && isGrounded()) // Walking
			{
				walkCycle.flipSpriteHorizontal = flipSpriteHorizontal;
				walkCycle.draw();

				//create particle system
				PlayerWalkingParticleSystem particleSystem = new PlayerWalkingParticleSystem(position, 1, 2, standingOn.particleColor);
				load(particleSystem);
			}
			else if ((InputHelper.isKeyDown(JUMP_KEY_1) || InputHelper.isKeyDown(JUMP_KEY_2))) //Jumping
			{
				animatedImageAir.flipSpriteHorizontal = flipSpriteHorizontal;
				animatedImageAir.draw();
			}
			else if (InputHelper.isKeyDown(DIG_KEY) && gameState == GameState.InGame) //Digging
			{
				animatedImageMine.flipSpriteHorizontal = flipSpriteHorizontal;
				animatedImageMine.draw();
			}
			else if(isGrounded == false) //Idle
			{
				animatedImageFall.flipSpriteHorizontal = flipSpriteHorizontal;
				animatedImageFall.draw();
			}
			else
			{
				animatedImageIdle.flipSpriteHorizontal = flipSpriteHorizontal;
				animatedImageIdle.draw();
			}
		}
	
		//Draw the shield
		//This has to go on the bottom of this function, otherwise it will draw behind the player
		if (this.shieldTimer > 0f)
		{
			myShield.draw();
		}
	}

	void doPlayerMovement()
	{
		//Allow endless jumps while swimming
		if (isSwimming)
		{
			isGrounded = true;
		}

		gravityForce = 1f;

		if ((InputHelper.isKeyDown(JUMP_KEY_1) || InputHelper.isKeyDown(JUMP_KEY_2)) && isGrounded())
		{
			if (!isSwimming)
			{
				addForce(new PVector(0, -jumpForce));
				runData.playerJumps++;
			}
			else
			{
				addForce(new PVector(0, -jumpForce/10));//Decrease jump force while swimming
			}
		}
		else if(!InputHelper.isKeyDown(JUMP_KEY_1) && !InputHelper.isKeyDown(JUMP_KEY_2) && !isGrounded())
		{
			//allow for short jumps
			gravityForce = 1.8f;
		}

		if (InputHelper.isKeyDown(DIG_KEY))
		{
			isMiningDown = true;

			if (isSwimming)
			{
				//Swim down
				addForce(new PVector(0, (jumpForce/10)));
			}
		}
		else
		{
			isMiningDown = false;
		}

		if (InputHelper.isKeyDown(LEFT_KEY))
		{
			addForce(new PVector(-speed, 0));
			isMiningLeft = true;
			flipSpriteHorizontal = false;
		}
		else
		{
			isMiningLeft = false;
		}

		if (InputHelper.isKeyDown(RIGHT_KEY))
		{
			addForce(new PVector(speed, 0));
			isMiningRight = true;
			flipSpriteHorizontal = true;
		}
		else
		{
			isMiningRight = false;
		}

		if (InputHelper.isKeyDown(INVENTORY_KEY_A))
		{ 
			if(canUseInventory(0))
			{
				useInventory(0);
			}

			InputHelper.onKeyReleased(INVENTORY_KEY_A);
		}
		
		if (InputHelper.isKeyDown(INVENTORY_KEY_B))
		{ 
			if(canUseInventory(1))
			{
				useInventory(1);
			}

			InputHelper.onKeyReleased(INVENTORY_KEY_B);
		}
	}

	void addScore(int scoreToAdd)
	{
		score += scoreToAdd;
	}

	private void digBonuses()
	{
		float extraShieldTime = timeInSeconds(10f);

		if (getDepth() > BONUSDEPTH && gotbonus1 == false)
		{
			shieldTimer += extraShieldTime;
			gotbonus1 = true;
		}
	}

	public void takeDamage(float damageTaken)
	{
		if (isImmortal || damageTaken == 0.0)
		{
			return;
		}

		if (isHurt == false)
		{
			// if the player has taken damage, add camera shake
			//40 is about max damage
			float stressToInduce = damageTaken / 10;
			println("stressToInduce: " + stressToInduce);
			camera.induceStress(stressToInduce);
			ui.prepareHealthFlash();

			AudioManager.playSoundEffect("HurtSound");
		}

		//needs to happen after camera shake because else 'isHurt' will be always true
		super.takeDamage(damageTaken);  
	}

	private void statusEffects()
	{
		//Decrease stun timer
		if (stunTimer > 0f)
		{
			stunTimer--;
			isMiningDown = false;
			isMiningLeft = false;
			isMiningRight = false;
		}

		if (shieldTimer > 0f)
		{
			shieldTimer--;
			this.isImmortal = true;
			// if (myShield.drawShield != true) 
			myShield.drawShield = true;
		}
		else
		{
			this.isImmortal = false;
			myShield.drawShield = false;
		}
	}

	public void die()
	{
		super.die();

		endRun();
	}

	boolean canPickup(Pickup pickup)
	{
		return true;
	}

	public boolean canPlayerInteract()
	{
		return true;
	}

	protected void afterMine(BaseObject object)
	{
		runData.playerBlocksMined++;
	}

	protected void useInventory(int slot)
	{
		super.useInventory(slot);

		runData.itemsUsed++;
	}

}
