public class UIController
{
	//Text
	private PFont titleFont;
	private PFont instructionFont;
	private PFont hudFont;
	private final float TITLE_FONT_SIZE = 120;
	private final float INSTRUCTION_FONT_SIZE = 40;
	private final float ACHIEVEMENT_FONT_SIZE = 25; 
	private final float HUD_FONT_SIZE = 30;

	private float subTextCounter = -60;

	//Title position
	private float titleXPos;
	private float titleYPos;

	//Colors
	private final color TITLE_COLOR = #ffa259;
	private final color WHITE = #FFFFFF;
	private final color BLACK = #000000;
	private final color RED = #FF0000;
	private final color GREEN = #00FF00;

	//Game HUD
	private float hudTextDistanceFromLeft = 10; //The distance from the left side of the screen 
	private float hudTextStartY = 90; //The height from with the hud start

	//Extra score to add
	private float extraBonusX;
	private float extraScoreLiveTimer;
	private int collectedPoints;
	private int scoreDisplay = 0;
	private boolean addedComboScore = false;

	//Achievement icon
	public ArrayList<AchievementImageFrame> achievementFrames = new ArrayList<AchievementImageFrame>();
	private int achievementDisplayTimer = 0; 
	private int showingAchievementId; 
	private int selectedAchievementFrameIndex = 0; 

	//Health
	private float healthBarHeight = 30; 
	private float healthBarWidth = 500; 
	private float barX = 10;
	private float barY = 10;

	private float slotOffsetY = 40; 
	private float slotSize = 60;
	private float slotOffsetX = slotSize * 1.5f;

	//Healthbar white flashy thing
	private color flashColor = color(255, 0, 0);

	private float maxBarOffset = 15; //how much we're bigger than the healthbar
	private float barOffset = 0;    //starts at maxBarOffset and then goes down

	private float tweenFactor = 0.98; //like a coefficient but for tweening
	private float killFactor = 0.01; //we stop the tweening at 0.01 of maxBarOffet

	//arrows
	private float arrowMoveTimer = -30;
	private float arrowYTarget = 0;
	private float arrowYOffset = 0;
	private float easing = 0.05f;

	//Overlay
	public float currentLoadingScreenTransitionFill = 0;
	private boolean drawWarningOverlay = false;
	private final float MAX_OVERLAY_FILL = 30f;
	private float currentOverlayFill = 0;
	private boolean isIncreasing = true;

	private final boolean DRAWSTATS = true;

	private final float MAX_DOT_TIMER = 20f; // half second
	private float nextDotTimer = MAX_DOT_TIMER;
	private String dots = "";

	private PImage healthBarImage;
	private PImage arrowImage;

	// graphics
	PGraphics leaderBoardGraphics;

	UIController()
	{
		titleFont = ResourceManager.getFont("Block Stock");
		instructionFont = ResourceManager.getFont("Block Stock");
		hudFont = ResourceManager.getFont("Block Stock");
		healthBarImage = ResourceManager.getImage("health-bar");
		arrowImage = ResourceManager.getImage("RedArrow");

		generateLeaderboardGraphics();
		updateTitlePosition();
	}

	void draw()
	{
		updateTitlePosition();

		//draw hud at center position
		rectMode(CENTER);
		textAlign(CENTER);

		// draw hud based on current gamestate
		switch (gameState)
		{
			case MainMenu:
				drawStartMenu();
			break;	

			case AchievementScreen:
				drawAchievementScreen(); 
			break; 

			case GameOver:
				drawGameOver();
			break;

			case InGame :
				drawGameHUD();
			break;

			case GamePaused :
				drawPauseScreen();
			break;

			default :
				//println("Something went wrong with the game state");
			break;
		}

		//reset rectMode
		rectMode(CORNER);
		textAlign(LEFT);
		drawWarningOverlay();

		if (DRAWSTATS)
		{
			drawStats();
		}
	}

	void updateTitlePosition()
	{
		//Draw the title in the middle of the screen
		titleXPos = width / 2;

		//Draw the title at about a forth of the screen height
		titleYPos = float(height) / 4f;
	}

	void drawWarningOverlay()
	{
		if (drawWarningOverlay && isIncreasing)
		{
			currentOverlayFill += 0.5f * TimeManager.deltaFix;

			if (currentOverlayFill > MAX_OVERLAY_FILL)
			{
				currentOverlayFill = MAX_OVERLAY_FILL;
				isIncreasing = false;
			}
		}
		else
		{
			currentOverlayFill -= 0.5f * TimeManager.deltaFix;

			if (currentOverlayFill < 0)
			{
				currentOverlayFill = 0;

				if (drawWarningOverlay)
				{
					isIncreasing = true;
				}
			}
		}

		if (currentOverlayFill == 0)
		{
			return;
		}

		fill(255, 0, 0, currentOverlayFill);
		rect(0, 0, width, height);
		fill(WHITE);
	}

	void drawArrows()
	{
		if (arrowMoveTimer < 0)
		{
			arrowYTarget = TILE_SIZE;
		}
		else
		{
			arrowYTarget = 0;

			if(arrowMoveTimer > 30)
			{
				arrowMoveTimer = -30;
			}
		}

		arrowMoveTimer += TimeManager.deltaFix;

		float dy = arrowYTarget - arrowYOffset;
		arrowYOffset += (dy * easing) * TimeManager.deltaFix;

		tint(255, 127);
		fill(TITLE_COLOR);
		textFont(instructionFont);
		textSize(INSTRUCTION_FONT_SIZE / 2);

		for (int i = 0; i < TILES_HORIZONTAL + 1; i += 2)
		{
			text("Dig!", i * TILE_SIZE, OVERWORLD_HEIGHT * TILE_SIZE + arrowYOffset - 15);
			image(arrowImage, i * TILE_SIZE, OVERWORLD_HEIGHT * TILE_SIZE + arrowYOffset);
		}

		tint(WHITE);
	}

	void drawGameOver()
	{
		checkComboAdded();

		drawTitle("GAME OVER");

		//sub text
		textFont(instructionFont);
		textSize(INSTRUCTION_FONT_SIZE);
		text("Score: " + scoreDisplay + "\nDepth: " + player.getDepth() + "m", width / 2, height / 2 + INSTRUCTION_FONT_SIZE);

		if(isUploadingRunResults)
		{
			handleDots();
			text("Uploading run stats" + dots, width / 2, height / 2 + INSTRUCTION_FONT_SIZE * 4);
		}
		else
		{
			text("Enter: restart", width / 2, height / 2 + INSTRUCTION_FONT_SIZE * 4);
		}
	}

	// because when the player dies, the current combo is never added, what this function fixed
	private void checkComboAdded()
	{
		if(!addedComboScore)
		{
			addedComboScore = true;
			scoreDisplay += collectedPoints;
		}
	}

	private void handleDots()
	{
		if(nextDotTimer < 0f)
		{
			dots += ".";
			nextDotTimer = MAX_DOT_TIMER;
		}

		if(dots.length() > 3)
		{
			dots = "";
		}

		nextDotTimer -= TimeManager.deltaFix;
	}

	void drawStartMenu()
	{
		fill(TITLE_COLOR);
		
		//sub text
		subTextCounter += TimeManager.deltaFix;

		textFont(instructionFont);
		textSize(ACHIEVEMENT_FONT_SIZE);
		text("Press space for achievements", width / 2, (height / 2.5) + (TITLE_FONT_SIZE/2));

		if (subTextCounter >= 0)
		{
			textSize(INSTRUCTION_FONT_SIZE);
			text("Press Start", width / 2, (height / 1.5) + (TITLE_FONT_SIZE/2));

			if(subTextCounter > 60)
			{
				subTextCounter = -60;
			}
		}

		handleLoadingScreenTransition();

		drawTitleImage();
	}

	private void handleLoadingScreenTransition()
	{
		if(currentLoadingScreenTransitionFill > 0)
		{
			currentLoadingScreenTransitionFill -= 4.5f * TimeManager.deltaFix;

			if(currentLoadingScreenTransitionFill < 0)
			{
				currentLoadingScreenTransitionFill = 0;
			}

			fill(0, currentLoadingScreenTransitionFill);
			rectMode(CORNER);
			rect(0, 0, width, height);
		}
	}

	void initAchievementFrames()
	{
		for(int i = 0; i < allAchievements.size(); i++)
		{
			AchievementImageFrame achievementFrame = new AchievementImageFrame(i, achievementHelper.getAchievementData(i).id);

			if(i == 0)
			{
				achievementFrame.isSelected = true; 
			}

			achievementFrames.add(achievementFrame); 
		}
	}
	
	void drawAchievementScreen()
	{
		fill(0, 175); 
		rect(0, 0, width * 2, height * 2); 

		for(AchievementImageFrame frame : achievementFrames)
		{
			frame.draw();  
		}

		if(InputHelper.isKeyDown(RIGHT_KEY))
		{
			if(selectedAchievementFrameIndex > achievementFrames.size()-2)
			{
				return; 
			}

			selectedAchievementFrameIndex++; 
			int selectedFrame = 0; 

			for(AchievementImageFrame frame : achievementFrames)
			{
				if(frame.isSelected)
				{
					selectedFrame = frame.achievementId; 
					frame.isSelected = false; 
				}
				frame.moveLeft(); 
				InputHelper.onKeyReleased(RIGHT_KEY); 
			}

			achievementFrames.get(selectedFrame + 1).isSelected = true; 
		}

		if(InputHelper.isKeyDown(LEFT_KEY))
		{
			if(selectedAchievementFrameIndex == 0)
			{
				return; 
			}

			selectedAchievementFrameIndex--; 
			int selectedFrame = 0; 

			for(AchievementImageFrame frame : achievementFrames)
			{
				if(frame.isSelected)
				{
					selectedFrame = frame.achievementId; 
					frame.isSelected = false; 
				}
				frame.moveRight(); 
				InputHelper.onKeyReleased(LEFT_KEY); 
			}

			achievementFrames.get(selectedFrame - 1).isSelected = true; 
		}
	}

	//Draw functions
	private void drawGameHUD()
	{
		drawHealthBar();

		//Draw the score and depth display
		textAlign(LEFT);
		textSize(HUD_FONT_SIZE);
		text("Score: " + scoreDisplay, hudTextDistanceFromLeft, hudTextStartY);
		float extraDistance = 10;
		text("Depth: " + player.getDepth() + "m", hudTextDistanceFromLeft, hudTextStartY + HUD_FONT_SIZE + extraDistance);

		//Draw powerups
		float powerupYPos = hudTextStartY + HUD_FONT_SIZE + 30;
		PImage shieldImage = ResourceManager.getImage("Shield");
		PImage magnetImage = ResourceManager.getImage("Magnet");
		drawPowerUp(shieldImage, hudTextDistanceFromLeft, powerupYPos, player.shieldTimer);
		drawPowerUp(magnetImage, hudTextDistanceFromLeft + 60, powerupYPos, player.magnetTimer);
		
		//Collected points display
		//Draw the collected score if the player has some
		if (collectedPoints > 0)
		{
			String comboChainText = "";

			if(extraScoreLiveTimer > 0)
			{
				if(collectedPoints >= 500 && collectedPoints < 1000)
				{
					comboChainText = "Not bad!";
				}
				else if(collectedPoints >= 1000 && collectedPoints < 2500)
				{
					comboChainText = "Nice!";
				}
				else if(collectedPoints >= 2500 && collectedPoints < 5000)
				{
					comboChainText = "Sick!";
				}
				else if(collectedPoints >= 5000 && collectedPoints < 10000)
				{
					comboChainText = "Awesome!";
				}
				else if(collectedPoints >= 10000)
				{
					comboChainText = "Rock Solid!!";
					
					if(!achievementHelper.hasUnlockedAchievement(COMBO_MASTER_ACHIEVEMENT))
					{
						achievementHelper.unlock(COMBO_MASTER_ACHIEVEMENT); 
					}
				}
			}

			text("+ " + collectedPoints + " " + comboChainText, extraBonusX, hudTextStartY);
		}

		if (extraScoreLiveTimer > 0)
		{
			extraScoreLiveTimer -= TimeManager.deltaFix;
		}
		else
		{
			float pointMoveSpeed = 15f;
			//Move the entire collected score display to the left
			extraBonusX -= pointMoveSpeed;
			//Add the score when it is beyond the display
			if (extraBonusX <= hudTextDistanceFromLeft)
			{
				scoreDisplay += collectedPoints;
				collectedPoints = 0;
			}
		}

		if(achievementDisplayTimer > 0)
		{
			displayAchievement(); 
			achievementDisplayTimer -= TimeManager.deltaFix; 
		}
	}

	private void drawPowerUp(PImage powerupImage, float xPos, float yPos, float powerUpTimer)
	{	
		float minTintValue = 56;
		float maxTintValue = 255;

		if (powerUpTimer > 0)
		{
			//Draw the image transparent to indicate it's not active
			tint(WHITE, maxTintValue);
		}
		else
		{
			//Draw the image fully colored to indicate that it is active
			tint(WHITE, minTintValue);
		}

		image(powerupImage, xPos, yPos);
		
		tint(255);
	}

	private void drawTitle(String menuText)
	{
		//Update the posotopn of the title,this will prefent the title from moving while the screenszie changes
		updateTitlePosition();
		fill(TITLE_COLOR);
		textFont(titleFont);
		textSize(TITLE_FONT_SIZE);
		textAlign(CENTER);
		text(menuText, titleXPos, titleYPos);
	}

	public float getExtraBonusX()
	{
		//Get the amount of digits in the score display,
		//then draw the extra score based on the distance
		String scoreDigits = str(scoreDisplay);
		int numberOfScoreDigits = scoreDigits.length();
		float bonusX = hudTextDistanceFromLeft + (HUD_FONT_SIZE * (7 + numberOfScoreDigits));

		return bonusX;
	}

	//This function draws the extra scored points right to the normal point counter
	public void drawExtraPoints(int scoreToAdd)
	{
		//Get a new postion if we need to
		extraBonusX = getExtraBonusX();
		//Reset the collected score counter
		float resetTimer = timeInSeconds(0.75f);
		extraScoreLiveTimer = resetTimer;
		collectedPoints += scoreToAdd;
	}

	void drawHealthBar()
	{
		rectMode(CORNER); 

		//the flash thing when you get hurt
		if(barOffset > maxBarOffset * killFactor) //it'll never truly hit 0, but 0.01 is close enough for us
		{
			fill(flashColor);
			//*2 because we also moved 10 to the left and up, so otherwise we'll just end up on the exact same lower right corner as the bar 
			rect(barX - barOffset, barY - barOffset, healthBarWidth + barOffset * 2, healthBarHeight + barOffset * 2); 

			barOffset *= tweenFactor; //bootleg tweening
		}

		fill(WHITE);
		rect(barX, barY, healthBarWidth, healthBarHeight);

		color healthBarColor = lerpColor(RED, GREEN, map(player.currentHealth, 0f, player.maxHealth, 0f, 1f));

		fill(healthBarColor);
		rect(barX, barY, map(player.currentHealth, 0, player.maxHealth, 0, healthBarWidth), healthBarHeight);    

		textFont(hudFont);

		textAlign(CENTER);
		fill(BLACK);
		textSize(HUD_FONT_SIZE / 2);
		text("Health", barX, barY + 7, healthBarWidth, healthBarHeight);
		fill(WHITE);
	}

	public void prepareHealthFlash()
	{
		barOffset = maxBarOffset;
	}

	void drawStats()
	{
		textFont(hudFont);
		textAlign(RIGHT);
		fill(WHITE);
		textSize(20);

		text(round(frameRate) + " FPS", width - 10, height - 60);
		text(updateList.size() + " objects", width - 10, height - 35);
		text("Player: " + dbUser.userName, width - 10, height - 10);
	}

	void drawPauseScreen()
	{
		drawTitle("Paused");

		//sub text
		textFont(instructionFont);
		textSize(INSTRUCTION_FONT_SIZE);
		text("Start: continue", width / 2, height / 2 - 30);
		text("Select: restart", width / 2, height / 2 + 60);
	}

	void startDisplayingAchievement(int id)
	{
		// Display the text for 2 seconds
		achievementDisplayTimer = 120; 
		showingAchievementId = id; 	
	}

	public void displayAchievement()
	{	
		final float unlockedTextOffset = 100;

		textFont(instructionFont);		
		textAlign(CENTER);
		textSize(INSTRUCTION_FONT_SIZE / 2);
		text("Achievement unlocked: ", width / 2, height / 2 - unlockedTextOffset);
		textSize(INSTRUCTION_FONT_SIZE);
		text(achievementHelper.getAchievementData(showingAchievementId).name, width / 2, height / 2); 	
	}

	private void generateLeaderboardGraphics()
	{
		leaderBoardGraphics = createGraphics(int(TILE_SIZE * 9), int(TILE_SIZE * 5));

		leaderBoardGraphics.beginDraw();

		leaderBoardGraphics.textAlign(CENTER, CENTER);
		leaderBoardGraphics.textFont(ResourceManager.getFont("Block Stock"));
		leaderBoardGraphics.textSize(25);
		leaderBoardGraphics.text("Leaderboard", (TILE_SIZE * 9) / 2, 20);

		leaderBoardGraphics.textSize(12);

		int i = 0;

		leaderBoardGraphics.textAlign(LEFT, CENTER);

		for (DbLeaderboardRow leaderboardRow : leaderBoard)
		{
			if(i == 0) //First place
			{
				leaderBoardGraphics.fill(#C98910);
			}
			else if(i == 1) //Second place
			{
				leaderBoardGraphics.fill(#A8A8A8);
			}
			else if(i == 2) //Third place
			{
				leaderBoardGraphics.fill(#cd7f32);
			}
			else if(leaderboardRow.userName.equals(dbUser.userName))
			{
				leaderBoardGraphics.fill(WHITE); // other color meybe?
			}
			else
			{
				leaderBoardGraphics.fill(WHITE);
			}
			
			leaderBoardGraphics.text("#" + (i + 1), 20, 53 + i * 20);
			leaderBoardGraphics.text(leaderboardRow.userName, 60, 53 + i * 20);
			leaderBoardGraphics.text(leaderboardRow.score, 260, 53 + i * 20);
			leaderBoardGraphics.text(leaderboardRow.depth + "m", 370, 53 + i * 20);

			//println("#" + (i + 1) + " " + leaderboardRow.userName + ": " + leaderboardRow.score + ", " + leaderboardRow.depth + "m");

			i++;
		}

		leaderBoardGraphics.endDraw();
	}

	public void generateScoreboardGraphic()
	{
		textSize(20);
		textAlign(LEFT);
		fill(WHITE);

		for (int i = 0; i < scoreboard.size(); i++)
		{
			ScoreboardRow currentRow = scoreboard.get(i);
			PImage pickupImage = ResourceManager.getImage(currentRow.imageName);

			image(pickupImage, 50, 0 + (40*i), 40, 40);
			text(currentRow.score, 100, 30 + 40*i);
		}
	}
}
