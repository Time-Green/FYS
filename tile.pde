class Tile{
  PVector position = new PVector();
  PVector positionWhole = new PVector(); //same as position, but pixels instead of complete tiles

  boolean destroyed;
  boolean isSolid = true;

  float hp = 4;

  PImage image;
  PImage destroyedImage;
  SoundFile breakSound;

  float caveSpawningNoiceScale = 0.1f;
  float caveSpawningPosibiltyScale = 0.68f;

  ArrayList<Atom> contents = new ArrayList<Atom>(); //all Atoms on that specific tile

  Tile(int x, int y) {
    position.x = x * tileWidth;
    position.y = y * tileHeight;

    positionWhole.x = x;
    positionWhole.y = y;

    destroyedImage = ResourceManager.getImage("DestroyedBlock");

    if(position.y > 1050 && noise(float(x) * caveSpawningNoiceScale, float(y) * caveSpawningNoiceScale) > caveSpawningPosibiltyScale){
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

      image(image, position.x, position.y, tileWidth, tileHeight);
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

  public void destroy() {
    playBreakSound();
    destroyed = true;
    isSolid = false;
  }

  private void playBreakSound(){
    breakSound.stop();
    breakSound.play();
  }
}
