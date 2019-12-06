class Meteor extends Movable {

  private final float MAXHORIZONTALVELOCITY = 15.0;
  private final float MINSIZE = 1.0;
  private final float MAXSIZE = 4.0;
  private final float BRIGHTNESS = 300;

  private float sizeModifier;

  Meteor() {
    worldBorderCheck = false;

    sizeModifier = random(MINSIZE, MAXSIZE);
    size.set(tileSize * sizeModifier, tileSize * sizeModifier);

    aerialDragFactor = 1.0f;
    velocity.set(random(-MAXHORIZONTALVELOCITY, MAXHORIZONTALVELOCITY), 0);
    image = ResourceManager.getImage("Meteor 2");

    setupLightSource(this, BRIGHTNESS, 1f);
  }

  void update() {

    if (Globals.gamePaused) {  
      return;
    }

    super.update(); 

    if (isGrounded) {
      load(new Explosion(position, 100 * sizeModifier, 50, true)); 
      delete(this);
    } else if (position.x < -size.x / 2 || position.x > world.getWidth() + size.x / 2) {
      delete(this);
    }
  }
}
