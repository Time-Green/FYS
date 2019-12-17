class StructureSpawner extends Movable
{
	String structureName;

	PVector structureSize = new PVector(0, 0);
	PVector spawnAt = new PVector();


	StructureSpawner(World world, String name, PVector target)
	{
		anchored = true;
		image = ResourceManager.getImage("Invisible");

		spawnAt.set(target);

		structureName = name;
		world.queuedStructures.add(this);

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
				Tile tile = world.getTile((spawnAt.x + x) * Globals.TILE_SIZE, (spawnAt.y + y) * Globals.TILE_SIZE);

				if (tile == null)
				{
					return;
				}
			}
		}

		world.spawnStructure(structureName, new PVector(spawnAt.x, spawnAt.y));
		delete(this);
	}

	void destroyed()
	{
		super.destroyed();
		world.queuedStructures.remove(this);
	}
}
