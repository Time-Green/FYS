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

	//For achievement purposes
	private boolean undamaged = true; 
	private int explosionsCaused = 0; 

	//Camera
	private float viewAmount = 400;
	private float viewTarget = viewAmount;
	private float easing = 0.025f;

	//Status effects
	public float stunTimer;
	public float shieldTimer;
	public float magnetTimer;
	public float extraRegenTimer;
	private float bonusRegen = regen * 2.5f;
	public boolean hurtFlash;

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

		setupAnimation();

		setupLightSource(this, viewAmount, 1f);

		applyRelicBoost();
	}

	void update()
	{
		if (gamePaused)
		{  
			return;
		}

		super.update();

		// This is used to tell the ui when to play the damage feedback
		hurtFlash = isHurt;

		if(getDepth() - OVERWORLD_HEIGHT > 100 && !achievementHelper.hasUnlockedAchievement(LONE_DIGGER_ACHIEVEMENT))
		{
			achievementHelper.unlock(LONE_DIGGER_ACHIEVEMENT); 
		}
		else if(getDepth() - OVERWORLD_HEIGHT > 1000 && !achievementHelper.hasUnlockedAchievement(PERSISTENCE_ACHIEVEMENT))
		{
			achievementHelper.unlock(PERSISTENCE_ACHIEVEMENT);
		}

		setVisibilityBasedOnCurrentBiome();

		checkHealthLow();

		statusEffects();

		if(getDepth() - OVERWORLD_HEIGHT > 500 && undamaged)
		{
			if(!achievementHelper.hasUnlockedAchievement(HARD_AS_A_ROCK_ACHIEVEMENT))
			{
				achievementHelper.unlock(HARD_AS_A_ROCK_ACHIEVEMENT); 
			}
		}

		if (stunTimer <= 0)
		{// Only move when we are not stunned
			doPlayerMovement();
		}
	}

	void checkHealthLow()
	{
		// if lower than 20% health, show low health overlay
		if (currentHealth < maxHealth / 5f)
		{
			ui.drawWarningOverlay = true;

			if (TimeManager.flooredDeltaFixFrameCount % 60 == 0)
			{
				AudioManager.playSoundEffect("LowHealth");
			}
		}
	}

	void checkLight()
	{
		if(isDark == true)
		{
			viewAmount = 20;
		}
		else
		{
			viewAmount = 400;
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
				speed += SPEED_BOOST * getRelicStrength(collectedRelicShardInventory.amount);
			}
			else if(collectedRelicShardInventory.relicshardid == 4)
			{
				viewAmount += LIGHT_BOOST * getRelicStrength(collectedRelicShardInventory.amount);
			}
		}
	}

	float getRelicStrength(float relicAmount)
	{
		return floor(relicAmount / 5);
	}

	void setVisibilityBasedOnCurrentBiome()
	{
		if (getDepth() > world.currentBiome.startedAt)
		{
			viewTarget = viewAmount * world.currentBiome.playerVisibilityScale;
		}

		float dy = viewTarget - lightEmitAmount;
		lightEmitAmount += (dy * easing) * TimeManager.deltaFix;
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
		handleParticles();
	}

	private void setupAnimation()
	{
		//Movement animation
		final int WALK_FRAMES = 4, IDLE_FRAMES = 3, MINE_FRAMES = 3;
		final int WALK_ANIMATION_SPEED = 8, IDLE_ANIMATION_SPEED = 1, MINE_ANIMATION_SPEED = 5;
		walkCycle = new AnimatedImage("PlayerWalk", WALK_FRAMES, WALK_ANIMATION_SPEED, position, size.x, flipSpriteHorizontal);
		animatedImageIdle = new AnimatedImage("PlayerIdle", IDLE_FRAMES, IDLE_ANIMATION_SPEED, position, size.x, flipSpriteHorizontal);
		animatedImageMine = new AnimatedImage("PlayerMine", MINE_FRAMES, MINE_ANIMATION_SPEED, position, size.x, flipSpriteHorizontal);
		
		//Jumping animation
		final int AIR_FRAMES = 3, FALL_FRAMES = 4;
		final int AIR_ANIMATION_SPEED = 10, FALL_ANIMATION_SPEED = 20;
		animatedImageAir = new AnimatedImage("PlayerAir", AIR_FRAMES, AIR_ANIMATION_SPEED, position, size.x, flipSpriteHorizontal);
    	animatedImageFall = new AnimatedImage("PlayerFall", FALL_FRAMES, FALL_ANIMATION_SPEED, position, size.x, flipSpriteHorizontal);

		//Status effects
		final int SHOCK_FRAMES = 2, FIRE_FRAMES = 4;
		final int STATUS_EFFECT_ANIMATION_SPEED = 10;
		animatedImageShocked = new AnimatedImage("PlayerShock", SHOCK_FRAMES, STATUS_EFFECT_ANIMATION_SPEED, position, size.x, flipSpriteHorizontal);
		animatedImageFire = new AnimatedImage("FireP", FIRE_FRAMES, STATUS_EFFECT_ANIMATION_SPEED, position, size.x, flipSpriteHorizontal);
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

		// Is the player stunned
		if (stunTimer > 0f)
		{
			animatedImageShocked.flipSpriteHorizontal = flipSpriteHorizontal;
			animatedImageShocked.draw();
		}
		else // Play the other animations when we are not stunned
		{
			if (abs(velocity.x) > 2 && isGrounded()) // Walking
			{
				walkCycle.flipSpriteHorizontal = flipSpriteHorizontal;
				walkCycle.draw();
			}
			else if (!isGrounded && velocity.y < 0) //Jumping
			{
				animatedImageAir.flipSpriteHorizontal = flipSpriteHorizontal;
				animatedImageAir.draw();
			}
			else if ((InputHelper.isKeyDown(DIG_KEY) || InputHelper.isKeyDown(LEFT_KEY) || InputHelper.isKeyDown(RIGHT_KEY)) && velocity.y < 7.5 && gameState == GameState.InGame) //Digging
			{
				animatedImageMine.flipSpriteHorizontal = flipSpriteHorizontal;
				animatedImageMine.draw();
			}
			else if(!isGrounded && velocity.y > 7.5) // falling
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

	private void handleParticles()
	{
		// Walking
		if (abs(velocity.x) > 2 && isGrounded() && TimeManager.flooredDeltaFixFrameCount % 3 == 0)
		{
			PlayerWalkingParticleSystem particleSystem = new PlayerWalkingParticleSystem(new PVector(position.x, position.y + 2.5f), 1, 3, standingOn.particleColor);
			load(particleSystem);
		}

		// Jumping
		if(isGrounded && (InputHelper.isKeyDown(JUMP_KEY_1) || InputHelper.isKeyDown(JUMP_KEY_2)))
		{
			PlayerWalkingParticleSystem particleSystem = new PlayerWalkingParticleSystem(new PVector(position.x, position.y + 2.5f), 12, 4, standingOn.particleColor);
			load(particleSystem);
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
				setForce(new PVector(0, -jumpForce));
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
	}

	void addScore(int scoreToAdd)
	{
		score += scoreToAdd;
	}

	public void takeDamage(float damageTaken)
	{
		if (isImmortal || damageTaken <= 0)
		{
			return;
		}

		undamaged = false; 

		if (isHurt == false)
		{
			// if the player has taken damage, add camera shake based on damage
			float stressToInduce = damageTaken / 10;

			camera.induceStress(stressToInduce);
			ui.prepareHealthFlash();

			AudioManager.playSoundEffect("HurtSound");
		}

		//needs to happen after camera shake because else 'isHurt' will be always true
		super.takeDamage(damageTaken);  
	}

	private void statusEffects()
	{
		if (stunTimer > 0f)
		{//Decrease stun timer
			stunTimer -= TimeManager.deltaFix;
			isMiningDown = false;
			isMiningLeft = false;
			isMiningRight = false;
		}

		// Shield
		if (shieldTimer > 0f)
		{
			shieldTimer -= TimeManager.deltaFix;
			isImmortal = true;
		}
		else
		{
			isImmortal = false;
		}

		//Magnet
		if (magnetTimer > 0f)
		{
			magnetTimer -= TimeManager.deltaFix;
		}

		// Get the default regen value so that we can use it later
		float defaultRegen = regen;

		// Extra regen powerup
		if (extraRegenTimer > 0f)
		{
			extraRegenTimer -= TimeManager.deltaFix;
			regen = bonusRegen;
		}
		else
		{
			regen = defaultRegen;
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
		if(object instanceof ExplosionTile)
		{
			explosionsCaused += 1; 

			if(explosionsCaused > 20 && !achievementHelper.hasUnlockedAchievement(MICHAEL_BAY_APPROVES_ACHIEVEMENT))
			{
				achievementHelper.unlock(MICHAEL_BAY_APPROVES_ACHIEVEMENT);
			}
		}

		runData.playerBlocksMined++;
	}
}
