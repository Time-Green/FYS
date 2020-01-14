class Button extends Obstacle
{ 
	private PImage pressedImage;
	private boolean canBePressed = true;

	Button()
	{
		size.set(50, 10);

		image = ResourceManager.getImage("Button");
		pressedImage = ResourceManager.getImage("ButtonPressed");

		drawLayer = PRIORITY_LAYER;
	}

	void update()
	{
		super.update();
	}

	void draw()
	{
		super.draw();

		if(canBePressed)
		{
			drawText();
		}
	}

	// draw the caution text above the button
	void drawText()
	{
		textAlign(CENTER);
		textSize(20);
		fill(#ffa259);

		text("Caution\nDo NOT press!!!", position.x + 20, position.y - 65);

		textAlign(LEFT);
	}

	// check of a movible objects (aka the player) has pressed the button
	void collidedWith(BaseObject object)
	{
		if(!(object instanceof Movable))
		{
			//anchored = true; //lock into place once we found a floor
			anchoredHorizontaly = true;

			return;
		}

		Movable presser = (Movable) object;

		// someone jumped on us
		if(canBePressed && presser.velocity.y > 1)
		{ 
			image = pressedImage;
			canBePressed = false;

			buttonPressed();
		}
	}

	// when the button is pressed, start the meteor rain next frame
	void buttonPressed()
	{
		startGameSoon();
	}

	// makes sure this objects gets deleted when it takes dammage
	void takeDamage(float damageTaken)
	{
		super.takeDamage(damageTaken);

		delete(this);
	}
}
