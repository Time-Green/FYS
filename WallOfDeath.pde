class WallOfDeath extends Movable
{
	private float minDistanceFromPlayer = 650f;
	private float maxDistanceFromPlayer = 1250f;
	private int currentDepthCheck = 0; 
	boolean isInBeginfase = true;
	private final int MAX_DEPTH_CHECK = 25; 

	private float lastPurge; //last y coord when we killed a bunch of stuff

	private color wallColor = #FF8C33;

	private float gameStartSpawnMult = 0; 

	private float bufferZone; 

	private final int DESTROYTILESAFTER = 10; //destroys tiles permanently x tiles behind the WoD

	private final float BEGINFASE_OVERWORLD_HEIGHT = 750; 

	WallOfDeath()
	{
		float worldWidth = TILES_HORIZONTAL * TILE_SIZE + TILE_SIZE;

		size.set(worldWidth, TILE_SIZE * 2);
		position.y = player.position.y - maxDistanceFromPlayer;

		//for debug only, Remove this line of code when puplishing
		collisionEnabled = false;

		//movement is not done with gravity but only with velocity
		gravityForce = 0f;
		groundedDragFactor = 1f;
	}

	void update()
	{
		if (gamePaused || gameState == GameState.Overworld)
		{
			return;
		}

		super.update();

		if (gameStartSpawnMult < 1)
		{
			gameStartSpawnMult += (1f / 600f) * TimeManager.deltaFix; // 10 second begin phase

			if (gameStartSpawnMult >= 1)
			{
				gameStartSpawnMult = 1; 
				isInBeginfase = false;
				ui.drawWarningOverlay = false;
			}
		}

		doStartingCameraShake();

		bufferZone = player.position.y - position.y; 
		//println(bufferZone); 

		//wod movement per frame
		position.y += (bufferZone / 225) * TimeManager.deltaFix;

		if (bufferZone < minDistanceFromPlayer)
		{
			position.y = player.position.y - minDistanceFromPlayer;
		}
		else if (bufferZone > maxDistanceFromPlayer)
		{
			position.y = player.position.y - maxDistanceFromPlayer;
		}

		float maxAsteroidSpawnChange = ((bufferZone + player.position.y * 0.085f) * 0.00004f) * gameStartSpawnMult;

		maxAsteroidSpawnChange *= TimeManager.deltaFix;
		maxAsteroidSpawnChange += 1;

		if (random(maxAsteroidSpawnChange) > 1)
		{     
			spawnAstroid();
		}

		if(lastPurge + TILE_SIZE * 5 < position.y) //so we only cleanup every object we pass
		{
			cleanUpObjects();
		}
	}

	void draw()
	{
		//don't draw anything
	}

	private void doStartingCameraShake()
	{
		if (gameState == GameState.InGame && isInBeginfase)
		{
			camera.induceStress(1f - gameStartSpawnMult * 1.5f);
		}
	}

	// If the WoD hits the player, the game is paused. 
	private void checkPlayerCollision()
	{
		if (CollisionHelper.rectRect(position, size, player.position, player.size))
		{
			gamePaused = true;
			gameState = GameState.GameOver;
		}
	}

	void spawnAstroid()
	{
		if (isInBeginfase)
		{
			spawnRandomTargetedMeteor();
		}
		else
		{
			// 20% change to spawn a meteor above the player
			if (random(1f) < 0.2f)
			{
				spawnMeteorAbovePlayer();
			}
			else
			{
				//max depth we are going to scan
				int scanDepth = currentDepthCheck + MAX_DEPTH_CHECK;

				Tile spawnTarget = null;

				for (int i = currentDepthCheck; i < scanDepth; i++)
				{
					ArrayList<Tile> tileRow = world.getLayer(i);
					ArrayList<Tile> destructibleTilesInRow = new ArrayList<Tile>();

					for (Tile tile : tileRow)
					{
						if (tile.density)
						{
							destructibleTilesInRow.add(tile);
						}
					}

					if (destructibleTilesInRow.size() > 0)
					{
						spawnTarget = destructibleTilesInRow.get(int(random(destructibleTilesInRow.size())));

						break;
					}
					else
					{
						currentDepthCheck++;
					}
				}

				if (spawnTarget != null)
				{
					spawnTargetedMeteor(spawnTarget.position.x);
				}
			}
		}
	}

	private void spawnTargetedMeteor(float targetPosX)
	{
		float spawnPosX = targetPosX + random(-TILE_SIZE * 2, TILE_SIZE * 2);

		load(new Meteor(), new PVector(spawnPosX, position.y));
	}

	private void spawnMeteorAbovePlayer()
	{
		float spawnPosX = player.position.x + random(-TILE_SIZE * 2, TILE_SIZE * 2);

		load(new Meteor(), new PVector(spawnPosX, position.y));
	}

	private void spawnRandomTargetedMeteor()
	{
		float spawnX = random(TILES_HORIZONTAL * TILE_SIZE + TILE_SIZE); 

		while (abs(player.position.x - spawnX) < BEGINFASE_OVERWORLD_HEIGHT)
		{
			spawnX = random(TILES_HORIZONTAL * TILE_SIZE + TILE_SIZE);
		}

		load(new Meteor(), new PVector(spawnX, position.y));
	}

	private void cleanUpObjects()
	{
		lastPurge = position.y;

		for (BaseObject object : updateList)
		{
			//is the object above the wall of death..
			if (object.position.y < position.y - DESTROYTILESAFTER * TILE_SIZE)
			{
				//..and its not the player or a particlesystem (fix for particle system not working)..
				if (object instanceof Player || object instanceof BaseParticleSystem || object.suspended)
				{
					continue;
				}

				//..https://www.youtube.com/watch?v=Kbx7m2qVVA0
				delete(object);
			}
		}
	}
}
