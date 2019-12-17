class BaseObject {

  protected PVector position = new PVector();
  protected final float OBJECTSIZE = 40f;
  protected PVector size = new PVector(OBJECTSIZE, OBJECTSIZE);
  protected boolean density = true;

  protected boolean loadInBack = false; //true to insert at the front of draw, so player doesn't get loaded behind tiles
  protected boolean movableCollision = false; //do we collide with movables themselves?

  boolean suspended = false; //set to true to stop drawing and updating, practically 'suspending' it outside of the game

  float lightningAmount = 255.0f; // the amount this object is lit up (0-255)
  float lightEmitAmount = 0.0f; // the amount of light this object emits
  float distanceDimFactor = 1;

  void update() {
    updateLightning();
  }

  void draw() {
  }

  private void updateLightning() {

    //if in overworld, fully lit up object
    if(position.y <= Globals.OVERWORLD_HEIGHT * Globals.TILE_SIZE + Globals.TILE_SIZE){
      lightningAmount = 255;

      return;
    }

    lightningAmount = 0;

    for (BaseObject lightSource : lightSources) {

      float distanceToLightSource = dist(position.x, position.y, lightSource.position.x, lightSource.position.y);

      //make sure we dont add to much light or remove brightness
      lightningAmount += constrain((lightSource.lightEmitAmount - distanceToLightSource) * lightSource.distanceDimFactor, 0, 255);
    }

    //make sure the object can't get brighter than 255
    lightningAmount = constrain(lightningAmount, 0, 255);
  }

  // check if this object is in camera view
  boolean inCameraView() {
    PVector camPos = camera.getPosition();

    if (position.y > -camPos.y - Globals.TILE_SIZE
      && position.y < -camPos.y + height
      && position.x > -camPos.x - Globals.TILE_SIZE
      && position.x < -camPos.x + width) {
      return true;
    }

    return false;
  }

  void destroyed() { //this is what you make a child proc from in-case you want to do something special on deletion
    objectList.remove(this);

    return;
  }

  void onDeleteQueued(){ //event for when we were QUEUED to be deleted. If our deletion meant deletion of others, it would cause
                         //a concurrentmodificationexception, so we need to do it instantly
  }

  void specialAdd() { //add to certain lists

    if (loadInBack) {
      //println("adding: " + name);
      objectList.add(0, this);
    } else {
      //println("adding: " + name);
      objectList.add(this);
    }
  }

  boolean canMine() { //could be useful for attacking
    return false;
  }

  void takeDamage(float damageTaken) {
  }

  void pushed(Movable movable, float x, float y) { //we got pushed by an movable
  }

  boolean canCollideWith(BaseObject object) { //return false for magically phasing through things. 
    return density;
  }

  void collidedWith(BaseObject object) {
  }

  protected int timeInSeconds(int seconds) {
    //* 60 milli seconds, 60 milliseconds is 1 second
    seconds *= 60;
    return seconds;
  }

  protected float timeInSeconds(float seconds) {
    //* 60 milli seconds, 60 milliseconds is 1 second
    seconds *= 60;
    return seconds;
  }
}
