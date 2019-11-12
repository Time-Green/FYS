class Tile extends BaseObject{
  PVector gridPosition = new PVector(); //same as position, but complete tiles instead of pixels

  boolean destroyed;

  private float maxHp, hp;

  PImage image;
  PImage destroyedImage;

  SoundFile breakSound;
  float dammageDiscolor = 50;

  float distanceToPlayer = 0.0f;

  Tile(int x, int y) {
    loadInBack = true;
    atomCollision = true;

    position.x = x * tileWidth;
    position.y = y * tileHeight;

    size.x = tileWidth;
    size.y = tileHeight;

    gridPosition.x = x;
    gridPosition.y = y;

    setMaxHp(2);

    destroyedImage = ResourceManager.getImage("DestroyedBlock");

    if(position.y > 1050 && noise(float(x) * world.CAVESPAWNINGNOICESCALE, float(y) * world.CAVESPAWNINGNOICESCALE) > world.CAVESPAWNINGPOSSIBILITYSCALE){
      destroyed = true;
      density = false;

      return;
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

  void update(){
    super.update();
  }

  void draw(){
    if(!inCameraView(camera)){
      return;
    }

    super.draw();

    if (!destroyed){

      //dirty NullPointerException fix
      if (image == null){
        return;
      }
      
      tint(lightningAmount - dammageDiscolor * (maxHp - hp));
      image(image, position.x, position.y, tileWidth, tileHeight);
      tint(255);
    }else{
      tint(lightningAmount);
      image(destroyedImage, position.x, position.y, tileWidth, tileHeight);
      tint(255);
    }
  }

  void takeDamage(float damageTaken) {
    hp -= damageTaken;
    
    if (hp <= 0) {
      mine();
    }
  }
  boolean canMine(){
    return density;
  }

  public void mine() {
    playBreakSound();
    destroyed = true;
    density = false;
  }

  private void playBreakSound(){
    breakSound.stop();
    breakSound.play();
  }

  void setMaxHp(int hpToSet){
    maxHp = hpToSet;
    hp = hpToSet;
  }
}
