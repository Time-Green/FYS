class Tile extends BaseObject
{
	PVector gridPosition = new PVector(); //same as position, but complete tiles instead of pixels

	boolean destroyed;

	float slipperiness = 1; //how much people slip on it. lower is slipperier

	private float maxHp, hp;
	public float healthMultiplier = 1;

	PImage image;
	PImage destroyedImage;

	String breakSound;
	float damageDiscolor = 50;

	Tile(int x, int y)
	{
		loadInBack = true;
		movableCollision = true;

		position.x = x * Globals.TILE_SIZE;
		position.y = y * Globals.TILE_SIZE;

		size.x = Globals.TILE_SIZE;
		size.y = Globals.TILE_SIZE;

		gridPosition.x = x;
		gridPosition.y = y;

		//the hp of the tile gows up the lower you go
		setMaxHp((2 + y / 250) * healthMultiplier);

		breakSound = "StoneBreak" + floor(random(1, 5));

		if (y > Globals.OVERWORLD_HEIGHT)
		{
			destroyedImage = ResourceManager.getImage("DestroyedBlock");
		}
		else
		{
			density = false; 
			destroyedImage = null;
		}
	}

	private void setupCave(World world)
	{
		//11 is grass layer + transition layer
		if (gridPosition.y > Globals.OVERWORLD_HEIGHT + 11 && noise(gridPosition.x * world.currentBiome.caveSpawningNoiseScale, gridPosition.y * world.currentBiome.caveSpawningNoiseScale) > world.currentBiome.caveSpawningPossibilityScale)
		{
			destroyed = true;
			density = false;

			//do a chance check first to save time and resources
			if(random(1) < world.currentBiome.ceilingObstacleChance)
			{
				world.currentBiome.prepareCeilingObstacle(this, world);
			}

			if (loadInBack == false)
			{
				loadInBack = true;
				reload(this);
			}

			//1% change to spawn torch
			if (random(100) < 1)
			{
				load(new Torch(), position);
			}

			if (random(1) < world.currentBiome.enemyChance)
			{
				world.currentBiome.spawnEnemy(position);
			}
		}
	}

	void specialAdd()
	{
		super.specialAdd();

		tileList.add(this);
	}

	void destroyed()
	{
		super.destroyed();

		world.map.get(int(gridPosition.y)).remove(this);
		tileList.remove(this);
	}

	void draw()
	{
		if (!inCameraView())
		{
			return;
		}

		super.draw();

		if (!destroyed)
		{
			//if we dont have an image, we cant draw anything
			if (image == null)
			{
				return;
			}

			tint(lightningAmount - damageDiscolor * (1 - (hp / maxHp)));
			image(image, position.x, position.y, Globals.TILE_SIZE, Globals.TILE_SIZE);
			tint(255);
		}
		else
		{
			if (destroyedImage != null) {
				tint(lightningAmount);
				image(destroyedImage, position.x, position.y, Globals.TILE_SIZE, Globals.TILE_SIZE);
				tint(255);
			}
		}
	}

	void update()
	{
		super.update();
	}

	void takeDamage(float damageTaken, boolean playBreakSound)
	{
		super.takeDamage(damageTaken);

		hp -= damageTaken;

		if (hp <= 0)
		{
			if (this instanceof ResourceTile)
			{
				ResourceTile thisTile = (ResourceTile) this;

				thisTile.mine(playBreakSound, false);
			}
			else
			{
				mine(playBreakSound);
			}
		}
	}

	void takeDamage(float damageTaken)
	{
		super.takeDamage(damageTaken);

		hp -= damageTaken;

		if (hp <= 0)
		{
			mine(true);
		}
	}

	boolean canMine()
	{
		return density;
	}

	public void mine(boolean playBreakSound)
	{
		if (playBreakSound && breakSound != null)
		{
			playBreakSound();
		}

		destroyed = true;
		density = false;
		loadInBack = true;
		reload(this);

		//if this tile generates light and is destroyed, disable the lightsource by removing it
		if (lightSources.contains(this))
		{
			lightSources.remove(this);
		}
	}

	private void playBreakSound()
	{
		AudioManager.playSoundEffect(breakSound);
	}

	void setMaxHp(float hpToSet)
	{
		maxHp = hpToSet;
		hp = hpToSet;
	}

	void replace(World world, Tile replaceTile)
	{
		int index = world.map.get(int(gridPosition.y)).indexOf(this);
		
		world.map.get(int(gridPosition.y)).set(index, replaceTile);

		delete(this);
		load(replaceTile);
	}
}
