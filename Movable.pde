class Movable extends BaseObject
{
	//Vectors
	protected PVector velocity = new PVector();
	protected PVector acceleration = new PVector();

	//Movement
	protected float speed = 1f;
	protected float jumpForce = 18f;
	protected float gravityForce = 1f;
	protected float groundedDragFactor = 0.90f;
	protected float slipperiness = 1; //stolen from tile to get slipperiness. set to 1 after being used
	protected float aerialDragFactor = 0.95f;
	protected float breakForce = 0.99f;
	protected float pushCoefficient = 1; //the higher, the easier

	//Bools
	protected boolean isGrounded;
	protected boolean isMiningDown, isMiningUp, isMiningLeft, isMiningRight;
	protected boolean collisionEnabled = true;
	protected boolean worldBorderCheck = true;
	protected boolean flipSpriteHorizontal;
	protected boolean flipSpriteVertical;
	protected boolean anchored = false; //true if we are completely immovable
	protected boolean anchoredHorizontaly = false;
	protected boolean rotateTowardsHeading = false;

	//Tiles
	protected int miningcolor = #DC143C;
	protected PImage image;
	protected Tile standingOn;

	//Enemies
	protected boolean walkLeft;
	protected int timesCollided;
	protected final int MAX_COLLISIONS = 10;

	Movable()
	{
		super();
	}

	void specialAdd()
	{
		super.specialAdd();
		movableList.add(this);
	}

	void destroyed()
	{
		super.destroyed();
		movableList.remove(this);
	}

	void update()
	{
		super.update();

		if (suspended)
		{
			return;
		}

		prepareMovement();
		doCollision();
		handleMovement(world);
	}

	void doCollision()
	{
		if (!collisionEnabled)
		{
			return;
		}

		isGrounded = false;
		ArrayList<Tile> colliders = new ArrayList<Tile>();

		colliders = checkCollision(world, 0, min(velocity.y, 0));

		//The way collision works is: We check all directions and see if we can move there. That way we can distinguish between
		//hitting your head and walking
		
		// up
		if (colliders.size() != 0)
		{
			for (BaseObject object : colliders)
			{
				object.pushed(this, 0, velocity.y); 

				if (isMiningUp)
				{
					attemptMine(object);
				} 
			}

			velocity.y = max(velocity.y, 0);
		}

		colliders = checkCollision(world, 0, max(velocity.y, 0));

		// down
		if (colliders.size() != 0)
		{
			isGrounded = true;    

			for (BaseObject object : colliders)
			{
				object.pushed(this, 0, velocity.y);

				if (isMiningDown)
				{
					attemptMine(object);
				}

				if (object instanceof Tile)
				{
					Tile tile = (Tile) object;

					standingOn = tile;
					slipperiness = tile.slipperiness;
				}
			}

			velocity.y = min(velocity.y, 0);
		}

		if (velocity.x < 0)
		{
			colliders = checkCollision(world, min(velocity.x, 0), 0);

			// left
			if (colliders.size() != 0)
			{

				//Enemy collision
				walkLeft = !walkLeft;
				timesCollided++;

				for (BaseObject object : colliders)
				{
					object.pushed(this, velocity.x, 0);

					if (isMiningLeft)
					{
						attemptMine(object);
					}
				}

				velocity.x = 0;
			}
		}
		else if (velocity.x > 0)
		{
			colliders = checkCollision(world, max(velocity.x, 0), 0);

			// right
			if (colliders.size() != 0)
			{
				//Enemy collision
				walkLeft =!walkLeft;
				timesCollided++;

				for (BaseObject object : colliders)
				{
					object.pushed(this, velocity.x, 0);

					if (isMiningRight)
					{
						attemptMine(object);
					}
				}

				velocity.x = 0;
			}
		}
	}

	void draw()
	{
		if (!inCameraView() || suspended)
		{
			return;
		}

		super.draw();

		if(image == null)
		{
			println("ERROR: Image for object '" + this + "' not found!");

			return;
		}

		pushMatrix();

		translate(position.x, position.y);

		if(rotateTowardsHeading)
		{
			float angle = velocity.heading();

			translate(size.x / 2, size.y / 2);
 			rotate(angle - radians(90));
		    translate(-size.x / 2, -size.y / 2);
		}

		tint(lightningAmount);

		if (!flipSpriteHorizontal && !flipSpriteVertical)
		{
			scale(1, 1);
			image(image, 0, 0, size.x, size.y);
		}
		else if (flipSpriteHorizontal && !flipSpriteVertical)
		{
			scale(-1, 1);
			image(image, -size.x, 0, size.x, size.y);
		}
		else if (!flipSpriteHorizontal && flipSpriteVertical)
		{
			scale(1, -1);
			image(image, 0, -size.y, size.x, size.y);
		}
		else if (flipSpriteHorizontal && flipSpriteVertical)
		{
			scale(-1, -1);
			image(image, -size.x, -size.y, size.x, size.y);
		}

		tint(255);

		popMatrix();
	}

	private void prepareMovement()
	{
		//gravity
		if(velocity.y < GRAVITY_LIMIT) //we have a special speed limit for gravity
		{
			acceleration.add(new PVector(0, gravityForce * TimeManager.deltaFix));
		}

		velocity.add(acceleration);
		velocity.limit(SPEED_LIMIT); //prevents us from going so fast we start ignoring collision

		acceleration.mult(0);

		if (isGrounded())
		{
			velocity.x *= min(groundedDragFactor * slipperiness, 1); //drag
		}
		else
		{
			velocity.x *= aerialDragFactor; //drag but in the air
		}

		slipperiness = 1;
	}

	private void handleMovement(World world)
	{
		PVector deltaFixVelocity = PVector.mult(velocity, TimeManager.deltaFix);

		if (!anchored)
		{
			if (!anchoredHorizontaly)
			{
				position.add(deltaFixVelocity);
			}
			else
			{
				position.add(new PVector(0, deltaFixVelocity.y));
			}
		}

		if (worldBorderCheck)
		{
			position.x = constrain(position.x, 0, world.getWidth() + 10);
		}
	}

	boolean isGrounded()
	{
		return isGrounded;
	}

	//amount of pixels we move
	void addForce(PVector forceToAdd)
	{
		if (!anchored)
		{
			acceleration.add(forceToAdd);
		}
	}

	void setForce(PVector newForce)
	{
		if (!anchored)
		{
			acceleration = newForce;
		}
	}

	ArrayList checkCollision(World world, float maybeX, float maybeY)
	{
		ArrayList<BaseObject> colliders = new ArrayList<BaseObject>(); 
		ArrayList<BaseObject> potentialColliders = new ArrayList<BaseObject>();

		potentialColliders.addAll(world.getSurroundingTiles(position.x, position.y, this));
		potentialColliders.addAll(movableList);

		for (BaseObject object : potentialColliders)
		{
			if (object == this)
			{
				continue;
			}

			if (CollisionHelper.rectRect(position.x + maybeX, position.y + maybeY, size.x, size.y, object.position.x, object.position.y, object.size.x, object.size.y))
			{
				if (!object.canCollideWith(this))
				{
					continue;
				}

				object.collidedWith(this);
				collidedWith(object);
				colliders.add(object);
			}
		}

		return colliders;
	}

	int getDepth()
	{
		return int(position.y / TILE_SIZE);
	}

	void attemptMine(BaseObject object)
	{
		return;
	}

	//use x and y, because whoever calls this needs fine controle over the directions that actually push, and this is easiest
	void pushed(Movable movable, float x, float y)
	{
		velocity.add(x * pushCoefficient, y * pushCoefficient);
	}

	boolean canCollideWith(BaseObject object)
	{
		if (!density)
		{
			return false;
		}

		return movableCollision || object.movableCollision;
	}
}
