class BaseObject
{
	protected PVector position = new PVector();
	protected final float OBJECTSIZE = 40f;
	protected PVector size = new PVector(OBJECTSIZE, OBJECTSIZE);
	protected boolean density = true;

	protected int drawLayer = OBJECT_LAYER; //true to insert at the front of draw, so player doesn't get loaded behind tiles
	protected boolean movableCollision = false; //do we collide with movables themselves?

	boolean suspended = false; //set to true to stop drawing and updating, practically 'suspending' it outside of the game

	boolean enableLightning = true;
	float lightningAmount = 255.0f; // the amount this object is lit up (0-255)
	float lightEmitAmount = 0.0f; // the amount of light this object emits
	float distanceDimFactor = 1;

	void update()
	{
		if(enableLightning)
		{
			updateLightning();
		}
	}

	void draw()
	{

	}

	void moveLayer(int newLayer)
	{
		removeFromDrawLayer();
		insertIntoDrawLayer(newLayer);

		drawLayer = newLayer;
	}

	void removeFromDrawLayer()
	{
		ArrayList<BaseObject> removeFrom = drawList.get(drawLayer);
		removeFrom.remove(this);
	}

	void insertIntoDrawLayer(int layer)
	{
		if(layer > drawingLayers)
		{
			println("ERROR: Attempted to draw " + this + " on a layer that doesn't exist! Increse drawingLayer in main.pde");
			return;
		}

		ArrayList<BaseObject> targetList = drawList.get(layer); //get the list inside the list on the right layer
		targetList.add(this);
	}

	private void updateLightning()
	{
		//if in overworld, fully lit up object
		if(position.y <= OVERWORLD_HEIGHT * TILE_SIZE + TILE_SIZE)
		{
			lightningAmount = 255;

			return;
		}

		lightningAmount = 0;

		for(BaseObject lightSource : lightSources)
		{
			float distanceToLightSource = dist(position.x, position.y, lightSource.position.x, lightSource.position.y);

			//make sure we dont add to much light or remove brightness
			lightningAmount += constrain((lightSource.lightEmitAmount - distanceToLightSource) * lightSource.distanceDimFactor, 0, 255);
		}

		//make sure the object can't get brighter than 255
		lightningAmount = constrain(lightningAmount, 0, 255);
	}

	// check if this object is in camera view
	boolean inCameraView()
	{
		PVector camPos = camera.getPosition();

		if (position.y > -camPos.y - TILE_SIZE
			&& position.y < -camPos.y + height
			&& position.x > -camPos.x - TILE_SIZE
			&& position.x < -camPos.x + width)
		{
			return true;
		}

		return false;
	}

	// this is what you make a child proc from in-case you want to do something special on deletion
	void destroyed()
	{
		updateList.remove(this);
		removeFromDrawLayer();

		return;
	}

	//event for when we were QUEUED to be deleted. If our deletion meant deletion of others, it would cause
	//a concurrentmodificationexception, so we need to do it instantly
	void onDeleteQueued()
	{

	}

	// add to certain lists
	void specialAdd()
	{
		updateList.add(this);
		insertIntoDrawLayer(drawLayer);

	}

	// could be useful for attacking
	boolean canMine()
	{ 
		return false;
	}

	void takeDamage(float damageTaken)
	{

	}

	// we got pushed by an movable
	void pushed(Movable movable, float x, float y)
	{ 

	}

	// return false for magically phasing through things. 
	boolean canCollideWith(BaseObject object)
	{ 
		return density;
	}

	void collidedWith(BaseObject object)
	{
		
	}

	// called upon being released from a tile, like icicles or flowers
	void unroot(Tile tile)
	{
		delete(this);
	}
}
