class Tile extends BaseObject {
  PVector gridPosition = new PVector(); //same as position, but complete tiles instead of pixels

  boolean destroyed;

  float slipperiness = 1; //how much people slip on it. lower is slipperier

  private float maxHp, hp;
  public float healthMultiplier = 1;

  PImage image;
  PImage destroyedImage;

  String breakSound;
  float damageDiscolor = 50;

  color particleColor = color(#45403d);

  //Decals - I'm so sorry, but I really don't know any other way that doesn't involve adding more objects
  String decalType;
  boolean[] decals = new boolean[DIRECTIONS]; //for all cardinal and diagonal directions

  boolean canParallax = true; //set to false to never use parallax on this tile and just use the destroyed image
  boolean parallaxDecals = true; //the ridges on non-dense tile transitioning into parallax tiles
  String parallaxDecalType;
  boolean parallaxed = false; //wheter or not we've been overwritten by a parallax image

  int destroyedLayer = BACKGROUND_LAYER;

  ArrayList<BaseObject> rootedIn = new ArrayList<BaseObject>();

  Tile(int x, int y) 
  {
    drawLayer = TILE_LAYER;
    movableCollision = true;

    position.x = x * TILE_SIZE;
    position.y = y * TILE_SIZE;

    size.x = TILE_SIZE;
    size.y = TILE_SIZE;

    gridPosition.x = x;
    gridPosition.y = y;

    //the hp of the tile gows up the lower you go
    setMaxHp((2 + y / 250) * healthMultiplier);

    breakSound = "StoneBreak" + floor(random(1, 5));

    if (y > OVERWORLD_HEIGHT) 
    {
      destroyedImage = ResourceManager.getImage("DestroyedBlock");
    } else 
    {
      density = false; 
      destroyedImage = null;
    }
  }

  private void setupCave(World world) {

    //11 is grass layer + transition layer
    if (gridPosition.y > OVERWORLD_HEIGHT + 11 && noise(gridPosition.x * world.currentBiome.caveSpawningNoiseScale, gridPosition.y * world.currentBiome.caveSpawningNoiseScale) > world.currentBiome.caveSpawningPossibilityScale) 
    {
      breakTile(true);

      if(random(1) < world.currentBiome.ceilingObstacleChance)
      { //do a chance check first to save time and resources
        world.currentBiome.prepareCeilingObstacle(this, world);
      }

      if (random(1) < world.currentBiome.enemyChance)
        world.currentBiome.spawnEnemy(position);
    }

    else
    {
      world.currentBiome.prepareGroundObstacle(this, world); //spawn something above us, like a plant, maybe
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
      image(image, position.x, position.y, TILE_SIZE, TILE_SIZE);
      drawDecals();
      tint(255);
    } 
    
    else
    {
      if (destroyedImage != null && (!PARALLAX_ENABLED || !canParallax)) 
      {
        tint(lightningAmount);
        image(destroyedImage, position.x, position.y, TILE_SIZE, TILE_SIZE);
        drawDecals();
      }
      else
      {
        tint(lightningAmount, 255 - lightningAmount); //second param is transparency. make the invisible tile less transparent and light, otherwise it doesnt work at all
        image(ResourceManager.getImage("Black"), position.x, position.y, TILE_SIZE, TILE_SIZE); //black so we can properly detransparant it. empty image doesnt work
      }
      tint(255);
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
      } else 
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

  public void mine(boolean playBreakSound) {

    if (playBreakSound && breakSound != null) 
    {
      playBreakSound();

		//create particle system
		TileBreakParticleSystem particleSystem = new TileBreakParticleSystem(position, 15, 6, particleColor);
		load(particleSystem);
    }

    breakTile(false);

    //if this tile generates light and is destroyed, disable the lightsource by removing it
    if (lightSources.contains(this)) 
    {
      lightSources.remove(this);
    }
  }

  void breakTile(boolean generated) //collection of what mining and generating a cave have in common so we dont copypaste it everywhere
  {
    destroyed = true;
    density = false;

    releaseRooted();
    moveLayer(destroyedLayer);
    makeNeighboursAesthetic();

    if(!generated)
    {
      resetDecals();
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

  void releaseRooted()
  { //destroy plants, drop icicles etc
    for(BaseObject rooted : rootedIn)
    {
      rooted.unroot(this);
    }
  }

  void addAesthetics()
  {
    //get all our cardinals 
    if(world == null) //we could pass world as a param, or we could just wait it out with the assumptions the air doesnt need decals
    {
      return;
    }

    if(!density && (!parallaxDecals || parallaxDecalType == null) || decalType == null)
    {
      return; //again we dont need airdecals or decals for those who dont want it
    }
    //cardinals
    Tile tileEast = world.getTile(position.x + TILE_SIZE, position.y);
    Tile tileWest = world.getTile(position.x - TILE_SIZE, position.y);
    Tile tileNorth = world.getTile(position.x, position.y - TILE_SIZE);
    Tile tileSouth = world.getTile(position.x, position.y + TILE_SIZE);

    //diagonals
    Tile tileNorthEast = world.getTile(position.x + TILE_SIZE, position.y - TILE_SIZE);
    Tile tileNorthWest = world.getTile(position.x - TILE_SIZE, position.y - TILE_SIZE);
    Tile tileSouthEast = world.getTile(position.x + TILE_SIZE, position.y + TILE_SIZE);
    Tile tileSouthWest = world.getTile(position.x - TILE_SIZE, position.y + TILE_SIZE);

    if(canDrawDecalsOn(tileEast))
    {
      decals[EAST] = true;
    }
    if(canDrawDecalsOn(tileWest))
    {
      decals[WEST] = true;    
    }
    if(canDrawDecalsOn(tileNorth))
    {
      decals[NORTH] = true;
    }
    if(canDrawDecalsOn(tileSouth))
    {
      decals[SOUTH] = true;
    }

    if(canDrawDecalsOn(tileNorthWest))
    {
      decals[NORTHWEST] = true;
    }
    if(canDrawDecalsOn(tileNorthEast))
    {
      decals[NORTHEAST] = true;
    }
    if(canDrawDecalsOn(tileSouthWest))
    {
      decals[SOUTHWEST] = true;
    }
    if(canDrawDecalsOn(tileSouthEast))
    {
      decals[SOUTHEAST] = true;
    }

  }

  boolean canDrawDecalsOn(Tile tile)
  {
    if(parallaxDecals && tile != null && tile.parallaxed && !parallaxed) //do we do parallaxdecals and is the other tile a parallax?
    {
      return true;
    }
    return density && tile != null && !tile.density;
  }

  void makeNeighboursAesthetic()
  {
    if(world == null) //we'll wait, air doesnt need decals anyway
    {
      return;
    }

    Tile[] tiles = {
      world.getTile(position.x + TILE_SIZE, position.y), 
      world.getTile(position.x - TILE_SIZE, position.y),
      world.getTile(position.x, position.y + TILE_SIZE),
      world.getTile(position.x, position.y - TILE_SIZE)
    };

    for(int i = 0; i < tiles.length; i++)
    {
      Tile tile = tiles[i];
      if(tile == null)
      {
        continue;
      }

      tile.addAesthetics();
    }
  }

  void resetDecals()
  {
    decals = new boolean[DIRECTIONS];
    addAesthetics();
  }

  void drawDecals(){
    String decal;

    if(!density && parallaxDecalType != null)
    {
      decal = parallaxDecalType;
    }
    else if(decalType != null)
    {
      decal = decalType;
    }
    else{
      resetDecals();;
      return;
    }

    if(decals[NORTH])
    {
      image(ResourceManager.getImage(decal + "_n"), position.x, position.y - TILE_SIZE, TILE_SIZE, TILE_SIZE);
    }
    if(decals[SOUTH])
    {
      image(ResourceManager.getImage(decal + "_s"), position.x, position.y + TILE_SIZE, TILE_SIZE, TILE_SIZE);
    }
    if(decals[WEST])
    {
      image(ResourceManager.getImage(decal + "_w"), position.x  - TILE_SIZE, position.y, TILE_SIZE, TILE_SIZE);
    }
    if(decals[EAST])
    {
      image(ResourceManager.getImage(decal + "_e"), position.x  + TILE_SIZE, position.y, TILE_SIZE, TILE_SIZE);
    }
    if(decals[NORTHEAST])
    {
      image(ResourceManager.getImage(decal + "_ne"), position.x + TILE_SIZE, position.y - TILE_SIZE, TILE_SIZE, TILE_SIZE);
    }
    if(decals[SOUTHEAST])
    {
      image(ResourceManager.getImage(decal + "_se"), position.x + TILE_SIZE, position.y + TILE_SIZE, TILE_SIZE, TILE_SIZE);
    }
    if(decals[NORTHWEST])
    {
      image(ResourceManager.getImage(decal + "_nw"), position.x  - TILE_SIZE, position.y - TILE_SIZE, TILE_SIZE, TILE_SIZE);
    }
    if(decals[SOUTHEAST])
    {
      image(ResourceManager.getImage(decal + "_se"), position.x  + TILE_SIZE, position.y + TILE_SIZE, TILE_SIZE, TILE_SIZE);
    }
  }
}
