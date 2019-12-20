public class Bird extends Mob
{
	AnimatedImage animatedImage;
	boolean flyingLeft = true;

	final float MIN_SPEED = 2.0f;
	final float MAX_SPEED = 5.0f;

	public Bird(World world)
	{
		//some birds will fly right
		if (random(0, 2) < 1)
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

		//animation speed based on x velocity
		animatedImage = new AnimatedImage("BirdFlying", 4, 20 - abs(velocity.x), position, size.x, flipSpriteHorizontal);
	}

	void draw()
	{
		animatedImage.draw();
	}

	void update()
	{
		super.update();

		if (flyingLeft && position.x < -32)
		{
			position.x = world.getWidth() + 100;
		}
		else if (!flyingLeft && position.x > world.getWidth() + 100)
		{
			position.x = -32;
		}

		if (isGrounded)
		{
			delete(this);
		}
	}

	void takeDamage(float damageTaken)
	{
		super.takeDamage(damageTaken);
		gravityForce = 0.5f;
	}
}
