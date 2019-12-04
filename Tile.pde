class Tile extends BaseObject{
  PVector gridPosition = new PVector(); //same as position, but complete tiles instead of pixels

  boolean destroyed;

  float slipperiness = 1; //how much people slip on it. lower is slipperier

  private float maxHp, hp;

  PImage image;
  PImage destroyedImage;

  String breakSound;
  float dammageDiscolor = 50;

  Tile(int x, int y) {
    loadInBack = true;
    movableCollision = true;

    position.x = x * tileWidth;
    position.y = y * tileHeight;

    size.x = tileWidth;
    size.y = tileHeight;

    gridPosition.x = x;
    gridPosition.y = y;

    setMaxHp(2);

    breakSound = "StoneBreak" + floor(random(1, 5));
    destroyedImage = ResourceManager.getImage("DestroyedBlock");
  }

  private void setupCave(){

    //11 is grass layer + transition layer
    if(gridPosition.y > world.safeZone + 11 && noise(gridPosition.x * world.currentBiome.caveSpawningNoiseScale, gridPosition.y * world.currentBiome.caveSpawningNoiseScale) > world.currentBiome.caveSpawningPossibilityScale){
      destroyed = true;
      density = false;

      //have a 2 in 10 change to spawn a enemy
      // float enemySpawnRate = random(10);
      // if (enemySpawnRate >= 8) 

      //1% change to spawn torch
      if(random(100) < 1) {
        load(new Torch(position));
      }
      if(random(1) < world.currentBiome.enemyChance)
        world.currentBiome.spawnEnemy(position);
    }
  }

  void specialAdd(){
    super.specialAdd();

    tileList.add(this);
  }

  void destroyed(){
    super.destroyed();

    world.map.get(int(gridPosition.y)).remove(this);
    tileList.remove(this);
  }

  void draw(){
    if(!inCameraView()){
      return;
    }

    super.draw();

    if (!destroyed){

      //if we dont have an image, we cant draw anything
      if (image == null){
        return;
      }
      
      tint(lightningAmount - dammageDiscolor * (maxHp - hp));
      image(image, position.x, position.y, tileWidth, tileHeight);
      tint(255);
    }else{

      if(destroyedImage != null){
        tint(lightningAmount);
        image(destroyedImage, position.x, position.y, tileWidth, tileHeight);
        tint(255);
      }
      
    }
  }

  void takeDamage(float damageTaken, boolean playBreakSound) {
    super.takeDamage(damageTaken);
    
    hp -= damageTaken;
    
    if (hp <= 0) {
      if(this instanceof ResourceTile){

        ResourceTile thisTile = (ResourceTile) this;

        thisTile.mine(playBreakSound, false);
      }else{
        mine(playBreakSound);
      } 
    }
  }

  void takeDamage(float damageTaken) {
    super.takeDamage(damageTaken);
    
    hp -= damageTaken;
    
    if (hp <= 0) {
      mine(true);
    }
  }
  
  boolean canMine(){
    return density;
  }

  public void mine(boolean playBreakSound){

    if(playBreakSound && breakSound != null){
      playBreakSound();
    }

    destroyed = true;
    density = false;

    //if this tile generates light and is destroyed, disable the lightsource by removing it
    if(lightSources.contains(this)){
      lightSources.remove(this);
    }
  }

  private void playBreakSound(){
    AudioManager.playSoundEffect(breakSound);
  }

  void setMaxHp(float hpToSet){
    maxHp = hpToSet;
    hp = hpToSet;
  }

  void replace(Tile replaceTile){
    int index = world.map.get(int(gridPosition.y)).indexOf(this);
    world.map.get(int(gridPosition.y)).set(index, replaceTile);

    delete(this);
    load(replaceTile);
    
  }
}
