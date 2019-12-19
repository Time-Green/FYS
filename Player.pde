class Player extends Mob
{
	//Animation
	private AnimatedImage walkCycle;
	private final int WALKFRAMES = 4;
	private AnimatedImage animatedImageIdle;
	private final int IDLEFRAMES = 3;
	private AnimatedImage animatedImageAir;
	private final int AIRFRAMES = 3;
	private AnimatedImage shockedCycle;
	private final int SHOCKFRAMES = 2;
	private AnimatedImage animatedImageMine;
	private final int MINEFRAMES = 3;
	private AnimatedImage animatedImageFall;
	private final int FALLFRAMES = 4;
	private AnimatedImage animatedImageFire;
	private final int FIREFRAMES = 4;

	//Camera
	private float viewAmount = 400;
	private float viewTarget = viewAmount;
	private float easing = 0.025f;

	private color particleColor = color(255);

	//Status effects
	public float stunTimer;

	private PVector spawnPosition = new PVector(1300, 509);
	public int score = 0;

	public Player()
	{
		position = spawnPosition;
		setMaxHp(100);
		baseDamage = 0.1; //low basedamage without pickaxe
		isSwimming = false;
		canRegen = true;
		jumpForce = 21f;

		walkCycle = new AnimatedImage("PlayerWalk", WALKFRAMES, 8, position, size.x, flipSpriteHorizontal);
		animatedImageIdle = new AnimatedImage("PlayerIdle", IDLEFRAMES, 60, position, size.x, flipSpriteHorizontal);
		animatedImageAir = new AnimatedImage("PlayerAir", AIRFRAMES, 10, position, size.x, flipSpriteHorizontal);
		shockedCycle = new AnimatedImage("PlayerShock", SHOCKFRAMES, 10, position, size.x, flipSpriteHorizontal);
		animatedImageMine = new AnimatedImage("PlayerMine", MINEFRAMES, 5, position, size.x, flipSpriteHorizontal);
    	animatedImageFall = new AnimatedImage("PlayerFall", FALLFRAMES, 20, position, size.x, flipSpriteHorizontal);
    	animatedImageFire = new AnimatedImage("FireP", FIREFRAMES, 10, position, size.x, flipSpriteHorizontal);

		setupLightSource(this, viewAmount, 1f);

		applyRelicBoost();
	}

	void update()
	{
		if (Globals.gamePaused)
		{  
			return;
		}

		super.update();

		if(player.getDepth() - Globals.OVERWORLD_HEIGHT > 100 && !achievementHelper.hasUnlockedAchievement(Globals.LONEDIGGERACHIEVEMENT))
		{
			achievementHelper.unlock(Globals.LONEDIGGERACHIEVEMENT); 
		}

		setVisibilityBasedOnCurrentBiome();

		checkHealthLow();

		statusEffects();

		if (stunTimer <= 0)
		{
			doPlayerMovement();
		}

	}

	void checkHealthLow()
	{
		// if lower than 20% health, show low health overlay
		if (currentHealth < maxHealth / 5f && currentHealth > maxHealth / 10f)
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
				baseDamage += Globals.DAMAGE_BOOST * getRelicStrength(collectedRelicShardInventory.amount);
			}
			else if(collectedRelicShardInventory.relicshardid == 1)
			{
				maxHealth += Globals.HEALTH_BOOST * getRelicStrength(collectedRelicShardInventory.amount);
				currentHealth += Globals.HEALTH_BOOST * getRelicStrength(collectedRelicShardInventory.amount);
			}
			else if(collectedRelicShardInventory.relicshardid == 2)
			{
				regen += Globals.REGEN_BOOST * getRelicStrength(collectedRelicShardInventory.amount);
			}
			else if(collectedRelicShardInventory.relicshardid == 3)
			{
				this.speed += Globals.SPEED_BOOST * getRelicStrength(collectedRelicShardInventory.amount);
			}
			else if(collectedRelicShardInventory.relicshardid == 4)
			{
				viewAmount += Globals.LIGHT_BOOST * getRelicStrength(collectedRelicShardInventory.amount);
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
		if(Globals.currentGameState == Globals.GameState.GameOver)
		{
			// dont draw when we are dead
			return;
		}

		if(Globals.gamePaused)
		{
			animatedImageIdle.flipSpriteHorizontal = flipSpriteHorizontal;
			animatedImageIdle.draw();

			return;
		}

		handleAnimation();

		// player only, because we'll never bother adding a holding sprite for every mob 
		for (Item item : inventory)
		{
			item.drawOnPlayer(this);
		}
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
			shockedCycle.flipSpriteHorizontal = flipSpriteHorizontal;
			shockedCycle.draw();
		}
		else // Play the other animations when we are not stunned
		{
			if ((InputHelper.isKeyDown(Globals.LEFTKEY) || InputHelper.isKeyDown(Globals.RIGHTKEY)) && isGrounded()) // Walking
			{
				walkCycle.flipSpriteHorizontal = flipSpriteHorizontal;
				walkCycle.draw();

				//create particle system
				PlayerWalkingParticleSystem particleSystem = new PlayerWalkingParticleSystem(position, 1, 2, particleColor);
				load(particleSystem);
			}
			else if ((InputHelper.isKeyDown(Globals.JUMPKEY1) || InputHelper.isKeyDown(Globals.JUMPKEY2))) //Jumping
			{
				animatedImageAir.flipSpriteHorizontal = flipSpriteHorizontal;
				animatedImageAir.draw();
			}
			else if (InputHelper.isKeyDown(Globals.DIGKEY) && Globals.currentGameState == Globals.GameState.InGame) //Digging
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
	}

	void doPlayerMovement()
	{
		//Allow endless jumps while swimming
		if (isSwimming)
		{
			isGrounded = true;
		}

		gravityForce = 1f;

		if ((InputHelper.isKeyDown(Globals.JUMPKEY1) || InputHelper.isKeyDown(Globals.JUMPKEY2)) && isGrounded())
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
		else if(!InputHelper.isKeyDown(Globals.JUMPKEY1) && !InputHelper.isKeyDown(Globals.JUMPKEY2) && !isGrounded())
		{
			//allow for short jumps
			gravityForce = 1.8f;
		}

		if (InputHelper.isKeyDown(Globals.DIGKEY))
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

		if (InputHelper.isKeyDown(Globals.LEFTKEY))
		{
			addForce(new PVector(-speed, 0));
			isMiningLeft = true;
			flipSpriteHorizontal = false;
		}
		else
		{
			isMiningLeft = false;
		}

		if (InputHelper.isKeyDown(Globals.RIGHTKEY))
		{
			addForce(new PVector(speed, 0));
			isMiningRight = true;
			flipSpriteHorizontal = true;
		}
		else
		{
			isMiningRight = false;
		}

		if (InputHelper.isKeyDown(Globals.INVENTORYKEY))
		{ 
			useInventory();
			InputHelper.onKeyReleased(Globals.INVENTORYKEY);
		}

		if (InputHelper.isKeyDown(Globals.ITEMKEY))
		{
			switchInventory();
			InputHelper.onKeyReleased(Globals.ITEMKEY);
		}

	}

	void addScore(int scoreToAdd)
	{
		score += scoreToAdd;
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
			CameraShaker.induceStress(damageTaken / 40);

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
	}

	public void die()
	{
		super.die();

		endRun();
	}

	boolean canPickUp(PickUp pickUp)
	{
		return true;
	}

	public boolean canPlayerInteract()
	{
		return true;
	}

	void afterMine(BaseObject object)
	{
		runData.playerBlocksMined++;
	}
}
