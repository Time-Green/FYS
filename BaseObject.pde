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

  void update(){
    updateLightning();
  }

  void draw(){

  }

  private void updateLightning(){

    lightningAmount = 0;

    for (BaseObject lightSource : lightSources){
      
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

    if (position.y > -camPos.y - tileSize
      && position.y < -camPos.y + height
      && position.x > -camPos.x - tileSize
      && position.x < -camPos.x + width) {
      return true;
    }

    return false;
  }

  void destroyed(){ //this is what you make a child proc from in-case you want to do something special on deletion
      objectList.remove(this);

      return;
  }

  void specialAdd(){ //add to certain lists

    if(loadInBack){
      //println("adding: " + name);
      objectList.add(0, this);
    }
    else{
      //println("adding: " + name);
      objectList.add(this); 
    }
  }

  boolean canMine(){ //could be useful for attacking
    return false;
  }

  void takeDamage(float damageTaken){

  }

  void pushed(Movable movable, float x, float y){ //we got pushed by an movable
    
  }

  public void moveTo(PVector newPosition){ //for moving to specific coords, but made so we could add some extra checks to it later if we need to
    position.set(newPosition);
  }

  public void moveTo(float x, float y){ //alt for just x and y
    moveTo(new PVector(x, y));
  }

  boolean canCollideWith(BaseObject object){ //return false for magically phasing through things. 
    return density;
  }

  void collidedWith(BaseObject object){
    
  }

}