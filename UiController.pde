public class UIController
{
	//Colors
	private color titleColor = #ffa259;
	private color titleBackground = #FFA500;
	private color inventoryColor = #FBB65E;
	private color inventorySelectedColor = #56BACF;

	//Game HUD
	private float hudTextStartX = 90;

	//Achievement icon
	private float iconFrameSize = 25; 
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

	//arrows
	float arrowYTarget = 0;
	float arrowYOffset = 0;
	float easing = 0.05f;

	//overlay
	boolean drawWarningOverlay = false;
	final float MAX_OVERLAY_FILL = 30f;
	float currentOverlayFill = 0;
	boolean isIncreasing = true;

	private final boolean DRAWSTATS = true;

	String dots = "";

	int scoreDisplay = 0;
	int depthDisplay = 0;

	//Inventory
	private float inventorySize = 50;

	private PImage healthBarImage;
	private PImage arrowImage;

	//Text
	private PFont titleFont;
	private float titleFontSize = 120;

	private PFont instructionFont;
	private float instructionFontSize = 40;

	private PFont hudFont;
	private float hudFontSize = 30;

	UIController()
	{
		titleFont = ResourceManager.getFont("Block Stock");
		instructionFont = ResourceManager.getFont("Block Stock");
		hudFont = ResourceManager.getFont("Block Stock");
		healthBarImage = ResourceManager.getImage("health-bar");
		arrowImage = ResourceManager.getImage("RedArrow");
	}

	void draw()
	{
		//draw hud at center position
		rectMode(CENTER);
		textAlign(CENTER, CENTER);

		// draw hud based on current gamestate
		switch (Globals.currentGameState)
		{
			default :
				//println("Something went wrong with the game state");
			break;

			case MainMenu:
				startMenu();
			break;	

			case GameOver:
				gameOver();
			break;

			case InGame :
			//case Overworld :
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
		fill(255);
	}

	void drawArrows()
	{
		if (frameCount % 30 == 0)
		{
			if (arrowYTarget == 0)
			{
				arrowYTarget = Globals.TILE_SIZE;
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

		for (int i = 0; i < Globals.TILES_HORIZONTAL + 1; i++)
		{

			if (i % 2 == 0)
			{
				continue;
			}

			text("Dig!", i * Globals.TILE_SIZE, Globals.OVERWORLD_HEIGHT * Globals.TILE_SIZE + arrowYOffset - 15);
			image(arrowImage, i * Globals.TILE_SIZE, Globals.OVERWORLD_HEIGHT * Globals.TILE_SIZE + arrowYOffset);
		}

		tint(255);
	}

	void gameOver()
	{
		//background rect pos & size
		float rectXPos = width / 2;
		float rectYPos = (float)height / 4.15;
		float rectWidth = width - titleFontSize * 4;
		float rectHeight = titleFontSize * 2.5;

		//title
		fill(titleColor);
		textFont(titleFont);
		textSize(titleFontSize);
		text("Game Over", rectXPos, rectYPos, rectWidth, rectHeight);

		//sub text
		textFont(instructionFont);
		textSize(instructionFontSize);
		text("Score: " + player.score + "\nDepth: " + player.getDepth() + "m", width / 2, height / 2 + instructionFontSize);

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
		//background rect pos & size
		float rectXPos = width / 2;
		float rectYPos = (float)height / 4.15;
		float rectWidth = width - titleFontSize * 4;
		float rectHeight = titleFontSize * 2.5;

		//title background
		textFont(titleFont);
		fill(titleBackground);

		//title
		fill(titleColor);
		textFont(titleFont);
		textSize(titleFontSize);
		text("ROCKY RAIN", rectXPos, rectYPos, rectWidth, rectHeight);

		//sub text
		if (Globals.currentGameState == Globals.GameState.MainMenu)
		{
			textFont(instructionFont);
			textSize(instructionFontSize);
			text("Press Start to start", width / 2, (height / 2) + (titleFontSize/2));
		}
	}

	void gameHUD()
	{
		rectMode(CORNER); 
		fill(255, 0, 0);
		rect(barX, barY, healthBarWidth, healthBarHeight); 
		fill(0, 255, 0);
		rect(barX, barY, map(player.currentHealth, 0, player.maxHealth, 0, healthBarWidth), healthBarHeight);    

		textFont(hudFont);

		textAlign(CENTER);
		fill(255);
		textSize(hudFontSize / 2);
		text("Health", barX, barY + 7, healthBarWidth, healthBarHeight);

		textAlign(LEFT);
		fill(255);
		textSize(hudFontSize);
		text("Score: " + player.score, 10, hudTextStartX);

		textAlign(LEFT);
		fill(255);
		textSize(hudFontSize);
		text("Depth: " + player.getDepth() + "m", 10, hudTextStartX + hudFontSize + 10);

		if(achievementDisplayTimer > 0)
		{
			displayAchievement(); 
			achievementDisplayTimer--; 
		}

		drawInventory();
	}

	void drawStats()
	{
		textFont(hudFont);
		textAlign(RIGHT);
		fill(255);
		textSize(20);

		text(round(frameRate) + " FPS", width - 10, 140);
		text(objectList.size() + " objects", width - 10, 120);
		text(round(wallOfDeath.position.y) + " WoD Y Pos", width - 10, 100);
		text(round(player.position.x) + " Player X Pos", width - 10, 80);
		text(round(player.position.y) + " Player Y Pos", width - 10, 60);
		text(round((player.position.y - wallOfDeath.position.y)) + " Player/WoD Y Div", width - 10, 40);
		text("Logged in as " + dbUser.userName, width - 10, 20);
	}

	void pauseScreen()
	{
		//background rect pos & size
		float rectXPos = width / 2;
		float rectYPos = (float)height / 4.15;
		float rectWidth = width - titleFontSize * 4;
		float rectHeight = titleFontSize * 2.5;

		//title
		textFont(titleFont);
		fill(titleColor);
		textSize(titleFontSize);
		text("Paused", rectXPos, rectYPos, rectWidth, rectHeight);

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
			if (i == player.selectedSlot - 1)
			{
				fill(inventorySelectedColor);
			}
			else
			{
				fill(inventoryColor);
			}

			//Get the first position we can draw from, then keep going until we get the ast possible postion and work back from there
			rect(width * 0.95 - inventorySize * i, barX, inventorySize, inventorySize);
		}

		for (Item item : player.inventory)
		{
			image(item.image, width * 0.95 - inventorySize * player.inventory.indexOf(item), barX, item.size.x, item.size.y);
		}
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
		text(achievementHelper.getAchievementData(showingAchievementId).name, width/2, height/2); 	
	}

	public void setupRunEnd()
	{
		ui.scoreDisplay = 0;
		ui.depthDisplay = 0;
		ui.drawWarningOverlay = false;
	}

	// private void handleScore()
	// {
	// 	if(scoreDisplay < player.score)
	// 	{
	// 		int scoreToAdd = round((player.score - scoreDisplay) / 15);

	// 		if(scoreToAdd == 0)
	// 		{
	// 			scoreToAdd++;
	// 		}

	// 		scoreDisplay += scoreToAdd;

	// 		if(scoreDisplay > player.score)
	// 		{
	// 			scoreDisplay = player.score;
	// 		}
	// 	}

	// 	if(depthDisplay < player.getDepth() - Globals.OVERWORLD_HEIGHT)
	// 	{
	// 		int depthToAdd = round((player.getDepth() - Globals.OVERWORLD_HEIGHT - depthDisplay) / 15);

	// 		if(depthToAdd == 0)
	// 		{
	// 			depthToAdd++;
	// 		}

	// 		depthDisplay += depthToAdd;

	// 		if(depthDisplay > player.getDepth() - Globals.OVERWORLD_HEIGHT)
	// 		{
	// 			depthDisplay = player.getDepth() - Globals.OVERWORLD_HEIGHT;
	// 		}
	// 	}
	// }
}
