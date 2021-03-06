class Biome
{
	int length = 50; //after how many tiles do we tell world to get another biome?

	float structureChance = 0.05; //chance of a structure spawning between 0 and 1 for every row of tiles
	float enemyChance = 0.01; //chance of enemy spawning on an open tile
	float ceilingObstacleChance = 0.0; //chance that a tile can have something hanging from it
	float groundObstacleChance = 0.1; //ditto but then ground

	int minimumDepth = 0; //minimum depth at wich we can appear
	int maximumDepth = 999999; //maximum depth at wich we can appear. Might be off by 10-20 tiles, due to the semi random biome depth

	float caveSpawningNoiseScale = 0.1f;
	float caveSpawningPossibilityScale = 0.68f; //lower for more caves 
	int startedAt; //world tells us at wich depth we started 

	boolean smoothTransit = true; //wheter we do the fusing thing with the biome UNDER us
	int transitWidth = 10; //how far we fuse with the biome UNDER us

	// the amount the player can see in the biome
	float playerVisibilityScale = 1;

	boolean canParallax = true; //wheter we can even use parallax. for stuff like the overworld, its a no

	boolean spawnMoss = true; //wheter this biome spawns moss
	color mossTint = color(23, 99, 0); //the tint of the moss. so we can have cool shadow moss for the shadow biome
	float mossChance = 0.0003; //chance a tile will spawn moss

	PImage destroyedImage = ResourceManager.getImage("DestroyedBlock");

  	Tile getTileToGenerate(int x, int depth)
  	{
    	if(spawnResourceTileAllowed(x, depth))
    	{
      		float oreChance = random(100);

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
			else if (depth > 15)
			{
				if (oreChance > 0 && oreChance <= 10)
				{
					return new CoalTile(x, depth);
				}
				else if (oreChance > 10 && oreChance <= 18)
				{
					return new IronTile(x, depth);
				}
				else if (oreChance > 18 && oreChance <= 20)
				{
					return new ExplosionTile(x, depth);
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
	  
	//return how long this biome is (not always super accurate, but it's fine)
  	int getLength()
  	{
    	return length;
  	}

	//place a structure at the given depth
  	void placeStructure(World world, int depth)
	{
    	world.safeSpawnStructure(getStructureName(), new PVector(int(random(TILES_HORIZONTAL * 0.8)), depth), false, true); //times 0.8 because stuff at the complete right usually cant spawn
  	}

	// a function so we can give some different probabilities
	String getStructureName()
	{
		final int dungeonAmount = 3;

		float spawnChance = random(1);

		// 50% chance to spawn a dungeon
		if(spawnChance < 0.5f)
		{
			return "Dungeon" + floor(random(dungeonAmount));
		}
		else // 50% chance to spawn a treasure chamber
		{
			float mimicChance = random(1);

			// 20% chance to spawn a mimic treasure chamber
			if (mimicChance < 0.2f)
			{
				return "TreasureChamberMimic";
			}
			else
			{
				return "TreasureChamber";
			}
		}
	}

	//spawn an enemy at the given position (the position is an open tile)
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
		else
		{
			load(new EnemyShocker(position));
		}
	}

	//ceiling obstacles like icicles are prepared here
  	void prepareCeilingObstacle(Tile target, World world)
	{
    	Tile above = world.getTile(target.position.x, target.position.y - TILE_SIZE);

    	if(above == null)
		{
      		return;
    	}

    	if(above.density)
		{
      		BaseObject object = spawnCeilingObstacle(target);
			target.rootedIn.add(object);
    	}
  	}

	//return an obstacle to stick to the roof
  	BaseObject spawnCeilingObstacle(Tile tile)
	{
		return load(new Icicle(), tile.position);
  	}

	//prepare stuff like flowers
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

	//return object that you want to stick into the ground
	BaseObject spawnGroundObstacle(Tile target)
	{
		return null;
	}

	//return the type of rock we should draw on the parallax
	String getParallaxedRock()
	{
		float chance = random(1);
		
		if(chance > 0.00 && chance < 0.10)
		{
			return "CoalBlock";
		}
		else if(chance > 0.10 && chance < 0.18)
		{
			return "IronBlock";
		}

		return "StoneBlock";
	}

	//spawn moss
	void spawnMoss(Tile tile, World world)
	{
		load(new Moss(tile, mossTint));
	}
}
