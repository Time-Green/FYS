public class World
{
	ArrayList<ArrayList<Tile>> map = new ArrayList<ArrayList<Tile>>();//2d list with y, x and Tile.
	ArrayList<StructureSpawner> queuedStructures = new ArrayList<StructureSpawner>();

	float deepestDepth = 0.0f; //the deepest point our player has been. Could definitely be a player variable, but I decided against it since it feels more like a global score
	int generateOffset = 25; // generate tiles 15 tiles below player, other 10 are air offset

	PImage dayNightImage;

	int birdCount = round(random(10, 15));

	Biome[] biomes = {new NormalBiome(), new HollowBiome(), new IceBiome(), new ShadowBiome(), new FireBiome()};
	Biome currentBiome;
	ArrayList<Biome> biomeQueue = new ArrayList<Biome>(); //queue the biomes here
	int switchDepth; //the depth at wich we switch to the next biome in the qeueu

	World()
	{
		dayNightImage = ResourceManager.getImage("DayNightCycle" + floor(random(0, 8)));

		//Specially queued biomes, for cinematic effect
		biomeQueue.add(new OverworldBiome());
		biomeQueue.add(new NormalBiome());
		// biomeQueue.add(new WaterBiome());

		fillBiomeQueue(0);
		switchBiome(0);

		updateWorldDepth();

		spawnOverworldStructures();
		spawnBirds();
		spawnNpcs();
		spawnStarterChest();
		spawnJukebox();
	}

	public void update()
	{

	}

	public void draw()
	{
		drawBackgoundImage();
	}

	public void spawnJukebox()
	{
		Jukebox jukebox = new Jukebox(new PVector(int(random(5, 25)) * TILE_SIZE, 510));
		load(jukebox);
	}

	void drawBackgoundImage()
	{
		float xPos = -camera.position.x - width * 0.1;
		float yPos = -camera.position.y * 0.5 - 200;

		float worldWidth = TILES_HORIZONTAL * TILE_SIZE + TILE_SIZE;

		pushMatrix();

		scale(1.1, 1.1);
		image(dayNightImage, xPos, yPos, worldWidth, dayNightImage.height);

		popMatrix(); 
	}

	void spawnOverworldStructures()
	{
		spawnStructure("Leaderboard", new PVector(12, 5));

		int lastSpawnX = -4;
		final int MIN_DISTANCE_INBETWEEN_TREE = 4;
		final int MAX_XSPAWNPOS = TILES_HORIZONTAL - 13;

		for (int i = 1; i < MAX_XSPAWNPOS; i++)
		{
			if (random(1) < 0.35f && i > lastSpawnX + MIN_DISTANCE_INBETWEEN_TREE && (i < 8 || i > 21))
			{
				lastSpawnX = i;
				spawnTree(new PVector(i, 6));
			}
		}

		spawnStructure("ButtonAltar", new PVector(40, 8));
	}

	void spawnTree(PVector location)
	{
		spawnStructure("Tree", location); 
	}

	void spawnBirds()
	{
		for (int i = 0; i < birdCount; i++)
		{
			Bird bird = new Bird(this);

			load(bird);
		}
	}

	// spawn devs
	void spawnNpcs()
	{
		String[] names = loadStrings("Texts/NpcNames.txt");
		String[] genericTexts = loadStrings("Texts/GenericTexts.txt");
		String[] panicTexts = loadStrings("Texts/PanicTexts.txt");

		for (int i = 0; i < 6; i++)
		{
			String[] personalTexts = loadStrings("Texts/" + names[i] + "Texts.txt");

			Npc npc = new Npc(this, names[i], genericTexts, panicTexts, personalTexts);

			load(npc, new PVector(random(50, 1650), 509));
		}
	}

	void spawnStarterChest()
	{
		load(new Chest(69), new PVector(36 * TILE_SIZE, 10 * TILE_SIZE)); //69 is the forcedKey for an always pickaxe spawn
	}

	//return tile you're currently on
	Tile getTile(float x, float y)
	{
		int yGridPos = floor(y / TILE_SIZE);

		if (yGridPos < 0 || yGridPos > map.size() - 1)
		{
			return null;
		}

		ArrayList<Tile> subList = map.get(yGridPos); //map.size() instead of tilesVertical, because the value can change and map.size() is always the most current

		int xGridPos = floor(x / TILE_SIZE);

		if (xGridPos < 0 || xGridPos >= subList.size())
		{
			return null;
		}

		return subList.get(xGridPos);
	}

	void updateWorldDepth()
	{
		int mapDepth = map.size();

		int playerDepth = OVERWORLD_HEIGHT;

		if(player != null)
		{
			playerDepth = player.getDepth();
		}

		for (int y = mapDepth; y <= playerDepth + generateOffset; y++)
		{
			ArrayList<Tile> subArray = new ArrayList<Tile>(); //make a list for the tiles

			if (canBiomeSwitch(y))
			{
				switchBiome(y);
			}

			if (y > OVERWORLD_HEIGHT + 11 && currentBiome.structureChance > random(1))
			{
				currentBiome.placeStructure(this, y);
			}

			for (int x = 0; x <= TILES_HORIZONTAL; x++)
			{
				Tile tile = currentBiome.getTileToGenerate(x, y);
				tile.destroyedImage = currentBiome.destroyedImage;

				subArray.add(tile);
				load(tile, true);

				tile.setupCave(this); //needs to be after load(tile) otherwise shit will get loaded anyway
			}

			map.add(subArray);// add the empty tile-list to the bigger list
		}

		for (StructureSpawner spawner : queuedStructures)
		{
			spawner.trySpawn(this);
		}

		postGenerate(map.size() - 2); //tell the row of tiles above us we're finished, so they can add 'aesthetics'
		//also minus -2 because we do -1 to get the the zero based index, and then minus -1 more to get the row above it
	}

	void postGenerate(int tilesIndex) //tell the row above is we're donzo, so they can add stuff like aesthetics
	{
		ArrayList<Tile> tiles = map.get(tilesIndex);
		for(Tile tile : tiles)
		{
			tile.addAesthetics();
		}
	}

	//returns an arraylist with the 8 tiles surrounding the coordinations. returns BaseObjects so that it can easily be joined with every object list
	//but it's still kinda weird I'll admit
	ArrayList<BaseObject> getSurroundingTiles(float x, float y, Movable collider)
	{ 
		ArrayList<BaseObject> surrounding = new ArrayList<BaseObject>();

		float middleX = x + collider.size.x * 0.5f; //calculate from the middle, because it's the average of all our colliding corners
		float middleY = y + collider.size.y * 0.5f;

		//cardinals
		Tile topTile = getTile(middleX, middleY - TILE_SIZE);

		if (topTile != null)
		{
			surrounding.add(topTile);
		}

		Tile botTile = getTile(middleX, middleY + TILE_SIZE);

		if (botTile != null)
		{
			surrounding.add(botTile);
		}

		Tile leftTile = getTile(middleX - TILE_SIZE, middleY);

		if (leftTile != null)
		{
			surrounding.add(leftTile);
		}

		Tile rightTile = getTile(middleX + TILE_SIZE, middleY);

		if (rightTile != null)
		{
			surrounding.add(rightTile);
		}

		//diagonals
		Tile botRightTile = getTile(middleX + TILE_SIZE, middleY + TILE_SIZE);

		if (botRightTile != null)
		{
			surrounding.add(botRightTile);
		}

		Tile botLeftTile = getTile(middleX - TILE_SIZE, middleY + TILE_SIZE);

		if (botLeftTile != null)
		{
			surrounding.add(botLeftTile);
		}

		Tile topLeftTile = getTile(middleX - TILE_SIZE, middleY - TILE_SIZE);

		if (topLeftTile != null)
		{
			surrounding.add(topLeftTile);
		}

		Tile topRightTile = getTile(middleX + TILE_SIZE, middleY - TILE_SIZE);

		if (topRightTile != null)
		{
			surrounding.add(topRightTile);
		}

		return surrounding;
	}

	ArrayList<Tile> getTilesInRadius (PVector pos, float radius)
	{
		ArrayList<Tile> returnList = new ArrayList<Tile>();

		for (Tile tile : tileList)
		{
			if (dist(pos.x, pos.y, tile.position.x, tile.position.y) < radius)
			{
				returnList.add(tile);
			}
		}

		return returnList;
	}

	// does some stuff related to the deepest depth, currently only infinite generation
	void updateDepth()
	{
		float depth = player.getDepth();

		// check if we're on a generation point and if we have not been there before
		if (depth > deepestDepth)
		{
			updateWorldDepth();
			deepestDepth = depth;
		}
	}

	ArrayList<Tile> getLayer(int layer)
	{
		return map.get(layer);
	}

	// return the X and Y in tiles
	PVector getGridPosition(Movable movable)
	{
		return new PVector(floor(movable.position.x / TILE_SIZE), floor(movable.position.y / TILE_SIZE));
	}

	float getWidth()
	{
		return TILES_HORIZONTAL * TILE_SIZE;
	}

	boolean canBiomeSwitch(int depth)
	{
		return depth > switchDepth;
	}

	void switchBiome(int depth)
	{
		if (biomeQueue.size() != 0)
		{
			currentBiome = biomeQueue.get(0);
			switchDepth += currentBiome.length;
			biomeQueue.remove(0);
			currentBiome.startedAt = depth;
		}
		else
		{
			fillBiomeQueue(depth);
		}
	}

	void fillBiomeQueue(int depth)
	{
		for (int i = 0; i < 10; i++)
		{
			ArrayList<Biome> possibleBiomes = new ArrayList<Biome>();

			for (Biome biome : biomes)
			{
				if (biome.minimumDepth > depth || biome.maximumDepth < depth) {
					continue;
				}

				possibleBiomes.add(biome);
			}

			Biome biome;

			if (possibleBiomes.size() > 0)
			{
				biome = possibleBiomes.get(int(random(possibleBiomes.size())));
			}
			else
			{
				biome = biomes[int(random(biomes.length))]; //plan B just grab a random one
			}

			depth += biome.getLength();
			biomeQueue.add(biome);
		}
	}

	void safeSpawnStructure(String structureName, PVector gridSpawnPos)
	{
		load(new StructureSpawner(this, structureName, gridSpawnPos), gridSpawnPos.mult(TILE_SIZE));
	}

	void spawnStructure(String structureName, PVector gridSpawnPos)
	{
		JSONArray layers = loadJSONArray(dataPath("Structures\\" + structureName + ".json"));

		for (int layerIndex = 0; layerIndex < layers.size(); layerIndex++)
		{
			JSONArray tiles = layers.getJSONArray(layerIndex);
			String[] tileValues = tiles.getStringArray();

			for (String tileString : tileValues)
			{
				String[] tileProperties = split(tileString, '|');

				if (tileProperties.length == 3)
				{
					String tileXPos = tileProperties[0];
					String tileYPos = tileProperties[1];
					String tileType = tileProperties[2];

					PVector structureTilePosition = new PVector(int(tileXPos), int(tileYPos));

					PVector worldTilePosition = new PVector();

					worldTilePosition.add(gridSpawnPos);
					worldTilePosition.add(structureTilePosition);

					// if layerIndex == 0 (background) replace the existing tile
					if (layerIndex == 0)
					{
						replaceObject(worldTilePosition, tileType, structureName, structureTilePosition);
					}
					else //else if layerIndex > 1, spawn on top of other tile (used for enemies, torch)
					{
						spawnObject(worldTilePosition, tileType);
					}
				}
			}
		}
	}

	private void replaceObject(PVector relaceAtGridPos, String newObjectName, String structureName, PVector structureTilePosition)
	{
		Tile tileToReplace = getTile(relaceAtGridPos.x * TILE_SIZE, relaceAtGridPos.y * TILE_SIZE);

		String stripedObjectName = stripName(newObjectName);
		Tile newTile = convertNameToTile(stripedObjectName, relaceAtGridPos, structureName, structureTilePosition);

		tileToReplace.replace(this, newTile);
	}

	private void spawnObject(PVector spawnAtGridPos, String newObjectName)
	{
		String stripedObjectName = stripName(newObjectName);

		spawnObjectByName(stripedObjectName, spawnAtGridPos);
	}

	private String stripName(String fullNamePath)
	{
		String[] objectPathSplit = split(fullNamePath, '\\');
		String stripedObjectName = objectPathSplit[objectPathSplit.length - 1].replace(".png", "").replace(".jpg", "");

		return stripedObjectName;
	}

	private Tile convertNameToTile(String stripedObjectName, PVector spawnPos, String structureName, PVector structureTilePosition)
	{
		switch(stripedObjectName)
		{
			case "DestroyedBlock" :
				Tile destroyedStoneTile = new StoneTile(int(spawnPos.x), int(spawnPos.y));

				destroyedStoneTile.mine(false);

				return destroyedStoneTile;

			case "WoodPlank" :
			
				if(structureName == "Leaderboard")
				{
					return new WoodPlankTile(int(spawnPos.x), int(spawnPos.y), structureTilePosition); // extra code needs to be ran at leaderboard
				}
				else
				{
					return new WoodPlankTile(int(spawnPos.x), int(spawnPos.y)); // extra code needs to be ran at leaderboard
				}

			case "DoorTop" :
				return new DoorTopTile(int(spawnPos.x), int(spawnPos.y));

			case "DoorBot" :
				return new DoorBotTile(int(spawnPos.x), int(spawnPos.y));

			case "Glass" :
				return new GlassTile(int(spawnPos.x), int(spawnPos.y));

			case "Leaf" :
				return new LeafTile(int(spawnPos.x), int(spawnPos.y));

			case "Wood" :
				return new WoodTile(int(spawnPos.x), int(spawnPos.y));

			case "WoodBirch" :
				return new WoodBirchTile(int(spawnPos.x), int(spawnPos.y));

			case "MagmaTile" :
				return new MagmaRock(int(spawnPos.x), int(spawnPos.y));

			case "ObsedianBlock" :
				return new ObsedianTile(int(spawnPos.x), int(spawnPos.y));

			case "DungeonBlock0" :
				return new DungeonBlock0(int(spawnPos.x), int(spawnPos.y));

			case "DungeonBlock1" :
				return new DungeonBlock1(int(spawnPos.x), int(spawnPos.y));

			case "DungeonBlock2" :
				return new DungeonBlock2(int(spawnPos.x), int(spawnPos.y));

			case "DungeonStairL" :
				return new DungeonStairL(int(spawnPos.x), int(spawnPos.y));

			case "DungeonStairR" :
				return new DungeonStairR(int(spawnPos.x), int(spawnPos.y));

			case "Fencepost" :
				return new Fencepost(int(spawnPos.x), int(spawnPos.y));
		}

		println("ERROR: structure tile '" + stripedObjectName + "' not set up or not found!");

		return new AirTile(int(spawnPos.x), int(spawnPos.y));
	}

	private void spawnObjectByName(String stripedObjectName, PVector spawnAtGridPos)
	{
		PVector spawnWorldPos = new PVector();

		spawnWorldPos.set(spawnAtGridPos);
		spawnWorldPos.mult(TILE_SIZE);

		switch(stripedObjectName)
		{
			case "Torch" :
				load(new Torch(), spawnWorldPos);
			break;

			case "BombEnemy" :
				load(new EnemyBomb(spawnWorldPos));
			break;

			case "Chest" :
				load(new Chest(), spawnWorldPos);
			break;

			case "Button" :
				load(new Button(), spawnWorldPos);
			break;

			case "Banner" :
				load(new Banner(), spawnWorldPos);
			break;

			case "Art0" :
				load(new Art0(), spawnWorldPos);
			break;

			case "Art1" :
				load(new Art1(), spawnWorldPos);
			break;

			case "ChairL" :
				load(new ChairL(), spawnWorldPos);
			break;

			case "ChairR" :
				load(new ChairR(), spawnWorldPos);
			break;

			case "Skull" :
				load(new Skull(), spawnWorldPos);
			break;

			case "SkullTorch" :
				load(new SkullTorch(), spawnWorldPos);
			break;

			case "Cobweb" :
				load(new Cobweb(), spawnWorldPos);
			break;

			case "Shelf0" :
				load(new Shelf0(), spawnWorldPos);
			break;

			case "Shelf1" :
				load(new Shelf1(), spawnWorldPos);
			break;

			case "Table" :
				load(new Table(), spawnWorldPos);
			break;

			default :
				println("ERROR: structure object '" + stripedObjectName + "' not set up or not found!");
			break;
		}
	}
}
