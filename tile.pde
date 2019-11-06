class Tile extends BaseObject{
  PVector gridPosition = new PVector(); //same as position, but complete tiles instead of pixels

  boolean destroyed;

  private float maxHp, hp;

  PImage image;
  PImage destroyedImage;
  SoundFile breakSound;
  float painDiscolor = 50;

  float caveSpawningNoiseScale = 0.1f;
  float caveSpawningPossibilityScale = 0.68f; //lower for more caves

  Tile(int x, int y) {
    loadInBack = true;

    position.x = x * tileWidth;
    position.y = y * tileHeight;

    size.x = tileWidth;
    size.y = tileHeight;

    gridPosition.x = x;
    gridPosition.y = y;

    setMaxHp(2);

    destroyedImage = ResourceManager.getImage("DestroyedBlock");

    if(position.y > 1050 && noise(float(x) * caveSpawningNoiseScale, float(y) * caveSpawningNoiseScale) > caveSpawningPossibilityScale){
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

  void update() {
  }

  void draw() {
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
