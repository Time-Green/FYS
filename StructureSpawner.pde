class StructureSpawner extends Movable
{
	String structureName;

	PVector structureSize = new PVector(0, 0);
	PVector spawnAt = new PVector();

	boolean lowerLeft = false; //if true, we assume the spawnAt to be the lower left instead of upper left

	StructureSpawner(World world, String name, PVector target, boolean lowerLeft)
	{
		anchored = true;
		image = ResourceManager.getImage("Invisible");

		spawnAt.set(target);

		structureName = name;
		world.queuedStructures.add(this);

		this.lowerLeft = lowerLeft;

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
					if (int(tileProperties[0]) > structureSize.x)
					{
						structureSize.x = int(tileProperties[0]);
					}

					if (int(tileProperties[1]) > structureSize.y)
					{
						structureSize.y = int(tileProperties[1]);
					}
				}
			}
		}
	}

	void trySpawn(World world)
	{
		for (int x = 0; x <= structureSize.x; x++)
		{
			for (int y = 0; y <= structureSize.y; y++)
			{
				Tile tile = world.getTile((spawnAt.x + x) * TILE_SIZE, (spawnAt.y + y) * TILE_SIZE);

				if (tile == null)
				{
					return;
				}
				
				if(world.isPositionInsideStructure(new PVector(spawnAt.x + x, spawnAt.y + y)))
				{
					return;
				}
			}
		}

		if(lowerLeft)
		{
			world.spawnStructure(structureName, new PVector(spawnAt.x, spawnAt.y - structureSize.y)); //spawn however tall we are, but up instead of down. useful for trees
		}
		else 
		{
			world.spawnStructure(structureName, new PVector(spawnAt.x, spawnAt.y));
		}

		world.addStructureLocation(spawnAt, structureSize);
		
		delete(this);
	}

	void destroyed()
	{
		super.destroyed();
		world.queuedStructures.remove(this);
	}
}
