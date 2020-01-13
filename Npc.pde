public class Npc extends Mob
{
	private String name;
	private color nameColor = #ffa259;

	private boolean isPanicking;

	// talking
	private String currentlySayingFullText;
	private String currentlySaying;
	private boolean isTalking, isAboutToTalk;
	private float currentTextIndex = 0;
	private float currentTalkingWaitTime = 0;
	private final int MAX_TALKING_WAIT_FRAMES = 2; // max frames untill showing next character when talking
	private float maxTalkingShowTime;
	private int timeStartedTalking;
	private float timeToStartTalking;
	private PImage textBaloon;
	String[] genericTexts;
	String[] panicTexts;
	String[] personalTexts;

	private AnimatedImage walkCycle;
	private final int WALKFRAMES = 4;
	private AnimatedImage animatedImageIdle;
	private final int IDLEFRAMES = 1;

	private int lastWalkingStateChange = millis();

	private float changeWalkingDirectionChance = 0.005f;
	private float panicChangeWalkingDirectionChance = 0.05f;
	private float doJumpChance = 0.0025f;
	private float panicDoJumpChance = 0.01f;
	private float changeIsWalkingChance = 0.005f;
	private float doTalkChance = 0.001f;

	private final float MIN_TIME_INBETWEEN_WALKING_CHANGE = 3 * 1000;
	private final float MIN_X = 50;
	private final float MAX_X = 1650;
	private boolean isWalking;

	public Npc(World world, String name, String[] genericTexts, String[] panicTexts, String[] personalTexts)
	{
		drawLayer = PRIORITY_LAYER;

		this.name = name;
		this.genericTexts = genericTexts;
		this.panicTexts = panicTexts;
		this.personalTexts = personalTexts;
		textBaloon = ResourceManager.getImage("TextBaloon");
		speed = 0.25f;
		jumpForce = 12f;

		changeWalkingDirection(0.5f);
		loadFrames();
	}

	private void loadFrames()
	{
		walkCycle = new AnimatedImage(name + "Walk", WALKFRAMES, 10, position, size.x, flipSpriteHorizontal);
		animatedImageIdle = new AnimatedImage(name + "Idle", IDLEFRAMES, 60, position, size.x, flipSpriteHorizontal);
	}

	void update()
	{
		if (gamePaused && gameState == GameState.InGame)
		{
			return;
		}
		
		super.update();

		if(gameState == GameState.InGame && !isPanicking)
		{
			panic();
		}

		handleMovement();
		handleTalking();
	}

	private void panic()
	{
		isPanicking = true;
		speed = 0.35f;
		changeWalkingDirectionChance = panicChangeWalkingDirectionChance;
		doJumpChance = panicDoJumpChance;

		startTalking();
	}

	private void handleMovement()
	{
		changeIsWalking(changeIsWalkingChance);

		borderCheck();

		if(isWalking)
		{
			addForce(new PVector(speed, 0));
		}

		changeWalkingDirection(changeWalkingDirectionChance);
		
		//chance to jump walking direction
		boolean doJump = random(1f) <= doJumpChance * TimeManager.deltaFix;

		if (doJump && isGrounded())
		{
			addForce(new PVector(0, -jumpForce));
		}
	}

	private void handleTalking()
	{
		if(isTalking)
		{
			if(millis() < timeToStartTalking)
			{
				return;
			}

			//stop talking after 5 seconds
			if(millis() - timeStartedTalking > maxTalkingShowTime)
			{
				isTalking = false;

				if(isPanicking)
				{
					startTalking();
				}

				return;
			}

			if(currentTalkingWaitTime < MAX_TALKING_WAIT_FRAMES)
			{
				currentTalkingWaitTime += TimeManager.deltaFix;

				return;
			}
			else
			{
				currentTalkingWaitTime = 0;
			}

			if(floor(currentTextIndex) < currentlySayingFullText.length())
			{
				currentTextIndex += TimeManager.deltaFix;

				int letterIndex = floor(currentTextIndex);

				if(letterIndex <= currentlySayingFullText.length())
				{
					currentlySaying = currentlySayingFullText.substring(0, letterIndex);
				}
			}
		}
		else if(!isPanicking)
		{
			//chance to start talking when not panicking
			boolean doTalk = random(1f) <= doTalkChance * TimeManager.deltaFix;

			if (doTalk)
			{
				startTalking();
			}
		}
	}

	private void startTalking()
	{
		timeToStartTalking = millis() + random(1500);
		timeStartedTalking = millis();
		maxTalkingShowTime = random(4000, 6000);
		currentTextIndex = 0;
		currentTalkingWaitTime = 0;
		currentlySayingFullText = getTextToSay();
		currentlySaying = "";
		isTalking = true;
	}

	private String getTextToSay()
	{
		String textToSay;

		if(isPanicking)
		{
			textToSay = panicTexts[floor(random(panicTexts.length))];
		}
		else
		{
			// random personal text
			if(random(1) <= 0.75f)
			{
				textToSay = personalTexts[floor(random(personalTexts.length))];
			}
			else // random generic text
			{
				textToSay = genericTexts[floor(random(genericTexts.length))];
			}
		}

		//insert player name
		return textToSay.replace("{PlayerName}", dbUser.userName);
	}

	private void borderCheck()
	{
		if(position.x <= MIN_X)
		{
			velocity.x = 0;
			changeWalkingDirection(1f);
			position.x = MIN_X + 5;
		}
		else if(position.x >= MAX_X)
		{
			velocity.x = 0;
			changeWalkingDirection(1f);
			position.x = MAX_X - 5;
		}
	}

	private void changeIsWalking(float chance)
	{
		if(isPanicking)
		{
			isWalking = true;

			return;
		}

		if(millis() - lastWalkingStateChange < MIN_TIME_INBETWEEN_WALKING_CHANGE)
		{
			//it was to soon we started/stopped walking, dont do anything
			return;
		}

		//chance to change walking direction
		boolean doChangeIsWalking = random(1f) <= chance * TimeManager.deltaFix;

		if(doChangeIsWalking)
		{
			isWalking = !isWalking;
			lastWalkingStateChange = millis();
		}
	}

	private void changeWalkingDirection(float chance)
	{
		//chance to change walking direction
		boolean doChangeWalkingDirection = random(1f) <= chance * TimeManager.deltaFix;

		if(doChangeWalkingDirection)
		{
			speed *= -1;
		}
	}

	void draw()
	{
		if (abs(velocity.x) > 0.1f && isGrounded()) //Walking
		{
			walkCycle.flipSpriteHorizontal = velocity.x >= 0;
			walkCycle.draw();
		}
		else //Idle
		{
			animatedImageIdle.flipSpriteHorizontal = velocity.x >= 0;
			animatedImageIdle.draw();
		}

		textAlign(CENTER);
		textSize(10);

		drawName();

		if(isTalking && millis() > timeToStartTalking)
		{
			drawTalking();
		}

		textAlign(LEFT);

		if(player.position.x > position.x - TILE_SIZE && player.position.x < position.x + TILE_SIZE)
		{
			drawAchievementHint(); 
		} 
	}

	private void drawName()
	{
		fill(nameColor);
		text(name, position.x + size.x / 2, position.y - 5);
	}

	private void drawAchievementHint()
	{
		if(isPanicking == false)
		{
			fill(255, 0, 0); 
			ellipseMode(CENTER);
			ellipse(this.position.x + 20, this.position.y - 40, 40, 40);
			fill(255); 
			textAlign(CENTER); 
			textSize(ui.ACHIEVEMENT_FONT_SIZE/1.5);
			text("A", this.position.x + 20, this.position.y - 32);
		}
	}

	private void drawTalking()
	{
		fill(0);
		image(textBaloon, position.x + 15, position.y - 25 - textBaloon.height / 1.5f, textBaloon.width / 1.5f, textBaloon.height / 1.5f);
		text(currentlySaying, position.x + 53, position.y - 100, textBaloon.width / 1.5f - 70, textBaloon.height / 1.5f);
	}

	void takeDamage(float damageTaken)
	{
		super.takeDamage(damageTaken);

		AudioManager.playSoundEffect("HurtSound", position);
		delete(this);
	}
}
