class Tile extends BaseObject{
  PVector gridPosition = new PVector(); //same as position, but complete tiles instead of pixels

  boolean destroyed;

  float slipperiness = 1; //how much people slip on it. lower is slipperier

  private float maxHp, hp;

  PImage image;
  PImage destroyedImage;

  SoundFile breakSound;
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

    destroyedImage = ResourceManager.getImage("DestroyedBlock");
  }

  private void setupCave(){
    if(position.y > 1050 && noise(gridPosition.x * world.currentBiome.caveSpawningNoiseScale, gridPosition.y * world.currentBiome.caveSpawningNoiseScale) > world.currentBiome.caveSpawningPossibilityScale){
      destroyed = true;
      density = false;

      //have a 2 in 10 change to spawn a enemy
      // float enemySpawnRate = random(10);
      // if (enemySpawnRate >= 8) 

      //5% change to spawn torch
      if(random(100) < 5) {
        load(new Torch(position));
      }
      if(random(100) < 3) {
        spawnEnemy();
      }
    }
  }

  private void spawnEnemy() {
    boolean hasSpawnedEnemy = false;

    if(hasSpawnedEnemy) return;


    float spawner = random(100);
    //Common enemies
    if (spawner > 0 && spawner < 45) load(new EnemyWalker(position));
    //Uncommon enemies
    else if (spawner > 45 && spawner < 60)  load(new EnemyGhost(position));
    else if (spawner > 60 && spawner < 75)  load(new EnemyBomb(position));
    else if (spawner > 75 && spawner < 90)  load(new EnemyDigger(position));
    //Rare enemies
    else if (spawner > 90 && spawner < 95)  load(new EnemyShocker(position));
    else if (spawner > 95) load(new EnemyMimic(position));

    hasSpawnedEnemy = true;
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
    breakSound.stop();
    //breakSound.play();
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
