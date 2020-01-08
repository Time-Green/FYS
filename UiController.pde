public class UIController
{
	//Text
	private PFont titleFont;
	private float titleFontSize = 120;

	private PFont instructionFont;
	private float instructionFontSize = 40;

	private float achievementUiSize = 25; 

	private PFont hudFont;
	private float hudFontSize = 30;

	int subTextCounter = -60;

	//Title position
	private float titleXPos;
	private float titleYPos;

	//Colors
	private color titleColor = #ffa259;
	private color titleBackground = #FFA500;
	private color inventoryColor = #FBB65E;
	private color inventorySelectedColor = #56BACF;

	private final color WHITE = #FFFFFF;
	private final color BLACK = #000000;
	private final color RED = #FF0000;

	//Game HUD
	private float hudTextDistanceFromLeft = 10; //The distance from the left side of the screen 
	private float hudTextStartY = 90; //The height from with the hub start

	//Extra score to add
	private float extraBonusX;
	String scoreText = "Score: ";
	private float extraScoreLiveTimer;
	private int collectedPoints;
	int scoreDisplay = 0;

	//Achievement icon
	ArrayList<achievementImageFrame> achievementFrames = new ArrayList<achievementImageFrame>();
	int achievementDisplayTimer = 0; 
	int showingAchievementId; 

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
	float arrowYTarget = 0;
	float arrowYOffset = 0;
	float easing = 0.05f;

	//Overlay
	boolean drawWarningOverlay = false;
	final float MAX_OVERLAY_FILL = 30f;
	float currentOverlayFill = 0;
	boolean isIncreasing = true;

	private final boolean DRAWSTATS = true;

	String dots = "";

	//Inventory
	private float inventorySize = 80;
	private float xSlot = 0.9; //these are all done in percentage of screen width/height so they can properly size with the screen
	private float ySlot = 0.08;
	private float slotXIncrement = 0.05; //how much we move for the next iteration of inventory slot (its two but lets support it)
	private float slotYIncrement = 0.07;

	private float imageEnlargement = 2; //how much we grow the item in our inventory

	private PImage healthBarImage;
	private PImage arrowImage;

	// graphics
	PGraphics leaderBoardGraphics;

	PImage cir;

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
			default :
				//println("Something went wrong with the game state");
			break;

			case MainMenu:
				startMenu();
			break;	

			case AchievementScreen:
				achievementScreen(); 
			break; 

			case GameOver:
				gameOver();
			break;

			//Temp
			// case Overworld :
			// 	generateScoreboardGraphic();
			// break;

			case InGame :
				gameHUD();
			break;

			case GamePaused :
				pauseScreen();
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

		//Draw the title about a third of the screen
		float distanceFromTheTop = 4.15;
		titleYPos = (float)height / distanceFromTheTop;
	}

	void drawWarningOverlay()
	{
		if (drawWarningOverlay && isIncreasing)
		{
			currentOverlayFill += 0.5f;

			if (currentOverlayFill > MAX_OVERLAY_FILL)
			{
				currentOverlayFill = MAX_OVERLAY_FILL;
				isIncreasing = false;
			}
		}
		else
		{
			currentOverlayFill -= 0.5f;

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
		if (frameCount % 30 == 0)
		{
			if (arrowYTarget == 0)
			{
				arrowYTarget = TILE_SIZE;
			}
			else
			{
				arrowYTarget = 0;
			}
		}

		float dy = arrowYTarget - arrowYOffset;
		arrowYOffset += dy * easing;

		tint(255, 127);
		fill(titleColor);
		textFont(instructionFont);
		textSize(instructionFontSize / 2);

		for (int i = 0; i < TILES_HORIZONTAL + 1; i++)
		{

			if (i % 2 == 0)
			{
				continue;
			}

			text("Dig!", i * TILE_SIZE, OVERWORLD_HEIGHT * TILE_SIZE + arrowYOffset - 15);
			image(arrowImage, i * TILE_SIZE, OVERWORLD_HEIGHT * TILE_SIZE + arrowYOffset);
		}

		tint(WHITE);
	}

	void gameOver()
	{
		drawTitle("GAME OVER");

		//sub text
		textFont(instructionFont);
		textSize(instructionFontSize);
		text("Score: " + scoreDisplay + "\nDepth: " + player.getDepth() + "m", width / 2, height / 2 + instructionFontSize);

		if(isUploadingRunResults)
		{
			handleDots();
			text("Uploading run stats" + dots, width / 2, height / 2 + instructionFontSize * 4);
		}
		else
		{
			text("Enter: restart", width / 2, height / 2 + instructionFontSize * 4);
		}
	}

	private void handleDots()
	{
		if(frameCount % 10 == 0)
		{
			dots += ".";
		}

		if(dots.length() > 3)
		{
			dots = "";
		}
	}

	void startMenu()
	{
		drawTitle("ROCKY RAIN");

		//sub text
		subTextCounter++;

		textFont(instructionFont);
		textSize(achievementUiSize);
		text("Press space to view achievements", width / 2, (height / 2.5) + (titleFontSize/2));

		if (subTextCounter >= 0)
		{
			textSize(instructionFontSize);
			text("Press Start", width / 2, (height / 1.5) + (titleFontSize/2));

			if(subTextCounter > 60)
			{
				subTextCounter = -60;
			}
		}
	}

	void initAchievementFrames()
	{
		for(int i = 0; i < allAchievements.size(); i++)
		{
			achievementFrames.add(new achievementImageFrame(i, achievementHelper.getAchievementData(i).id)); 
		}
	}
	
	void achievementScreen()
	{
		fill(0, 0, 0, 50); 
		rect(0, 0, width * 2, height * 2); 

		for(int i = 0; i < achievementFrames.size(); i++)
		{
			achievementFrames.get(i).draw();  
		}

	}

	void gameHUD()
	{
		drawHealthBar();

		//Draw the score and depth display
		textAlign(LEFT);
		textSize(hudFontSize);
		text(scoreText + scoreDisplay, hudTextDistanceFromLeft, hudTextStartY);
		text("Depth: " + player.getDepth() + "m", hudTextDistanceFromLeft, hudTextStartY + hudFontSize + 10);

		//Collected points display
		//Draw the collected score if we have some
		if (collectedPoints > 0)
		{
			text("+ " + collectedPoints, extraBonusX, hudTextStartY);
		}

		if (extraScoreLiveTimer > 0)
		{
			extraScoreLiveTimer--;
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
			achievementDisplayTimer--; 
		}

		drawInventory();
	}

	//Draw functions

	private void drawTitle(String menuText)
	{
		//Update the posotopn of the title,this will prefent the title from moving while the screenszie changes
		updateTitlePosition();
		fill(titleColor);
		textFont(titleFont);
		textSize(titleFontSize);
		textAlign(CENTER);
		text(menuText, titleXPos, titleYPos);
	}

	public float getExtraBonusX()
	{
		//Get the amount of digits in the score display,
		//then draw the extra score based on the distance
		String scoreDigits = str(scoreDisplay);
		int numberOfScoreDigits = scoreDigits.length();
		float bonusX = hudTextDistanceFromLeft + (hudFontSize * (scoreText.length() + numberOfScoreDigits));

		return bonusX;
	}

	//This function draws the extra scored points right to the normal point counter
	public void drawExtraPoints(int scoreToAdd)
	{
		//Get a new postion if we need to
		extraBonusX = getExtraBonusX();
		//Reset the collected score counter
		float resetTimer = timeInSeconds(0.5f);
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
			noStroke();
		}

		fill(WHITE);
		rect(barX, barY, healthBarWidth, healthBarHeight); 
		fill(0, 255, 0);
		rect(barX, barY, map(player.currentHealth, 0, player.maxHealth, 0, healthBarWidth), healthBarHeight);    

		stroke(0); //we may've changed the stroke in the flashy thing olf the healthbar

		textFont(hudFont);

		textAlign(CENTER);
		fill(BLACK);
		textSize(hudFontSize / 2);
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

		text(round(frameRate) + " FPS", width - 10, height - 130);
		text(updateList.size() + " objects", width - 10, height - 110);
		text(round(wallOfDeath.position.y) + " WoD Y Pos", width - 10, height - 90);
		text(round(player.position.x) + " Player X Pos", width - 10, height - 70);
		text(round(player.position.y) + " Player Y Pos", width - 10, height - 50);
		text(round((player.position.y - wallOfDeath.position.y)) + " Player/WoD Y Div", width - 10, height - 30);
		text("Logged in as " + dbUser.userName, width - 10, height - 10);
	}

	void pauseScreen()
	{
		drawTitle("Paused");

		//sub text
		textFont(instructionFont);
		textSize(instructionFontSize);
		text("Start: continue", width / 2, height / 2 - 30);
		text("Select: restart", width / 2, height / 2 + 60);
	}

	void drawInventory()
	{
		for (int i = 0; i < player.maxInventory; i++)
		{
			//Get the first position we can draw from, then keep going until we get the ast possible postion and work back from there
			PVector slotLocation = getInventorySlotLocation(i);
			ellipse(slotLocation.x, slotLocation.y, inventorySize, inventorySize);
		}

		imageMode(CENTER);
		
		for (int i = 0; i < player.inventory.length; i++)
		{
			if(player.inventory[i] != null && player.inventoryDrawable[i])
			{
				Item item = player.inventory[i];
				PVector slotLocation = getInventorySlotLocation(i);
				image(item.image, slotLocation.x, slotLocation.y, item.size.x * imageEnlargement, item.size.y * imageEnlargement);
			}
		}

		imageMode(CORNER); 
	}

	PVector getInventorySlotLocation(int slot)
	{
		return new PVector(width * (xSlot + slot * slotXIncrement), height * (ySlot + slot * slotYIncrement));
		
	}

	void startDisplayingAchievement(int id)
	{
		// Display the text for 2 seconds
		achievementDisplayTimer = 120; 
		showingAchievementId = id; 	
	}

	public void displayAchievement()
	{	
		textFont(instructionFont);
		textSize(instructionFontSize);
		textAlign(CENTER);
		text(achievementHelper.getAchievementData(showingAchievementId).name, width/2, height/2); 	
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


	//This is basic and full of magic numbers, remove them
	//I will write comments later i'm in a hurry atm
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
			// println(currentRow.imageName + "...." + currentRow.score);
		}
	}
}
