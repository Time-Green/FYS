public class Bird extends Mob
{
	AnimatedImage animatedImage;
	boolean flyingLeft = true;

	final float MIN_SPEED = 2.0f;
	final float MAX_SPEED = 5.0f;

	public Bird(World world)
	{
		//some birds will fly right
		if (random(0, 1) < 0.5f)
		{
			flyingLeft = false;
		}

		//set spawn position and velocity
		position.set(random(0, world.getWidth()), random(100, 350));
		velocity.set(random(MIN_SPEED, MAX_SPEED), 0);

		if (flyingLeft)
		{
			flipSpriteHorizontal = true;  
			velocity.mult(-1);
		}

		//set dragfactors to 1 so we dont slow down by drag
		groundedDragFactor = 1f;
		aerialDragFactor = 1f;

		//disable gravity
		gravityForce = 0f;

		//allow bird to fly of the screen
		worldBorderCheck = false;

		//some birds will fly in front of the trees, some don't
		if (random(0, 1) < 0.5f)
		{
			drawLayer = PRIORITY_LAYER;
		}

		//animation speed based on x velocity
		animatedImage = new AnimatedImage("BirdFlying", 4, 20 - abs(velocity.x), position, size.x, flipSpriteHorizontal);
	}

	void draw()
	{
		animatedImage.draw();
	}

	void update()
	{
		// don't update the object if we are paused
		if (gamePaused && gameState == GameState.InGame)
		{
			return;
		}
		
		super.update();
		
		borderCheck();

		// if the bird landed on the ground, delete it
		if (isGrounded)
		{
			delete(this);
		}
	}

	// when it leaves the screen, respawn at the other side
	private void borderCheck()
	{
		if (flyingLeft && position.x < -32)
		{
			position.x = world.getWidth() + 100;
		}
		else if (!flyingLeft && position.x > world.getWidth() + 100)
		{
			position.x = -32;
		}
	}

	// when we take dammage, fall out of the sky
	void takeDamage(float damageTaken)
	{
		super.takeDamage(damageTaken);

		gravityForce = 0.5f;
	}
}
