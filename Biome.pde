class Biome
{
	int length = 50; //after how many tiles do we tell world to get another biome?

	float structureChance = 0.001; //chance of a structure spawning between 0 and 1 for every row of tiles
	float enemyChance = 0.01; //chance of enemy spawning on an open tile
	float ceilingObstacleChance = 0.0; //chance that a tile can have something hanging from it
	float groundObstacleChance = 0.1; //ditto but then ground

	int minimumDepth = 0;
	int maximumDepth = 999999;

	float caveSpawningNoiseScale = 0.1f;
	float caveSpawningPossibilityScale = 0.68f; //lower for more caves
	int startedAt;

	// the amount the player can see in the biome
	float playerVisibilityScale = 1;

	boolean canParallax = true;

	PImage destroyedImage = ResourceManager.getImage("DestroyedBlock");


  	Tile getTileToGenerate(int x, int depth)
  	{
    	if(spawnResourceTileAllowed(x, depth))
    	{
      		float orechance = random(100);

			//spawn air at surface
			if (depth <= OVERWORLD_HEIGHT)
			{
				return new AirTile(x, depth);
			}
			else if (depth <= OVERWORLD_HEIGHT + 1)
			{
				return new GrassTile(x, depth);
			}
			else if (depth < 15)
			{
				return new DirtTile(x, depth);
			}
			else if (depth == 15)
			{
				return new DirtStoneTransitionTile(x, depth);
			}
			else if (depth > 15 && depth <= 500)
			{
				if (orechance > 80 && orechance <= 90)
				{
					return new CoalTile(x, depth);
				}
				else if (orechance > 90 && orechance <= 98)
				{
					return new IronTile(x, depth);
				}
				else if (orechance > 98 && orechance <= 100)
				{
					return new ExplosionTile(x, depth);
				}
			}
			else if (depth > 500)
			{
				if (orechance > 80 && orechance <= 88)
				{
					return new GoldTile(x, depth, 0);
				}
				else if (orechance > 88 && orechance <= 93)
				{
					return new RedstoneTile(x, depth, 0);
				}
				else if (orechance > 93 && orechance <= 96)
				{
					return new DiamondTile(x, depth, 0);
				}
				else if (orechance > 96 && orechance <= 98)
				{
					return new AmethystTile(x, depth, 0);
				}
				else if (orechance > 98 && orechance <= 100)
				{
					return new ObsedianTile(x, depth);
				}
      		}
    	}

    	//if no special tile was selected, spawn stone
    	return new StoneTile(x, depth);
  	}

  	// Never spawn resources directly underneath the player, to discourage the player from just digging straight down
  	public boolean spawnResourceTileAllowed(int x, int depth)
	{
		if(player != null && depth > OVERWORLD_HEIGHT + 11 && abs(x * TILE_SIZE - player.position.x) < TILE_SIZE * 3)
		{
			return false;
		}

		return true;
  	}

  	int getLength()
  	{
    	return length;
  	}

  	void placeStructure(World world, int depth)
	{
    	world.safeSpawnStructure(getStructureName(), new PVector(int(random(TILES_HORIZONTAL * 0.8)), depth)); //times 0.8 because stuff at the complete right usually cant spawn
  	}

	// a function so we can give some different probabilities
  	String getStructureName()
	{
    	return "SuperBasicDungeon";
  	}

	void spawnEnemy(PVector position)
	{
		float spawner = random(1);

		if (spawner < .3)
		{
			load(new EnemyWalker(position));
		}
		else if (spawner < .6)
		{
			load(new EnemyBomb(position));
		}
		else if (spawner < .8)
		{
			load(new EnemyDigger(position));
		}
		else if (spawner < .85)
		{
			load(new EnemyMimic(position));
		}
		else
		{
			load(new EnemyShocker(position));
		}
	}

  	void prepareCeilingObstacle(Tile target, World world)
	{
    	Tile above = world.getTile(target.position.x, target.position.y - TILE_SIZE);

    	if(above == null)
		{
      		return;
    	}

    	if(above.density)
		{
      		spawnCeilingObstacle(target);
    	}
  	}

  	void spawnCeilingObstacle(Tile tile)
	{
		load(new Icicle(), tile.position);
  	}
	
	void prepareGroundObstacle(Tile target, World world)
	{
		Tile above = world.getTile(target.position.x, target.position.y - TILE_SIZE); //get the tile above us

    	if(random(1) < groundObstacleChance && above != null && !above.density)
		{
			BaseObject rooter = spawnGroundObstacle(above);

			if(rooter != null)
			{
				target.rootedIn.add(rooter);
			}
		}
	}

	BaseObject spawnGroundObstacle(Tile target)
	{
		return null;
	}

	String getParallaxedRock()
	{
		return "StoneBlock";
	}
}
