class Tile{
  PVector position = new PVector();
  PVector positionWhole = new PVector(); //same as position, but complete tiles instead of pixels

  boolean destroyed;
  boolean isSolid = true;

  private float maxHp, hp;

  PImage image;
  PImage destroyedImage;
  SoundFile breakSound;
  float painDiscolor = 50;

  float caveSpawningNoiseScale = 0.1f;
  float caveSpawningPossibilityScale = 0.68f; //lower for more caves

  ArrayList<Atom> contents = new ArrayList<Atom>(); //all Atoms on that specific tile

  Tile(int x, int y) {
    position.x = x * tileWidth;
    position.y = y * tileHeight;

    positionWhole.x = x;
    positionWhole.y = y;

    setMaxHp(4);

    destroyedImage = ResourceManager.getImage("DestroyedBlock");

    if(position.y > 1050 && noise(float(x) * caveSpawningNoiseScale, float(y) * caveSpawningNoiseScale) > caveSpawningPossibilityScale){
      destroyed = true;
      isSolid = false;

      return;
    }
  }

  void update() {
    
  }

  void draw(Camera camera) {
    if(!inCameraView(camera)){
      return;
    }

    if (!destroyed){

      //dirty NullPointerException fix
      if (image == null) {
        return;
      }
      tint(255 - painDiscolor * (maxHp - hp));
      image(image, position.x, position.y, tileWidth, tileHeight);
      tint(255);
    }else{
      image(destroyedImage, position.x, position.y, tileWidth, tileHeight);
    }
  }

  boolean inCameraView(Camera camera) {
    PVector camPos = camera.getPosition();

    if (position.y > -camPos.y - tileHeight
      && position.y < -camPos.y + height
      && position.x > -camPos.x - tileWidth
      && position.x < -camPos.x + width) {
      return true;
    }

    return false;
  }

  void takeDamage(float damageTaken) {
    hp -= damageTaken;
    
    if (hp <= 0) {
      destroy();
    }
  }
  boolean canMine(){
    return isSolid;
  }

  public void destroy() {
    playBreakSound();
    destroyed = true;
    isSolid = false;
  }

  public void delete(){
    world.tileDestroy.add(this);
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
