class BaseObject {

  protected PVector position = new PVector(0,0);
  protected final float OBJECTSIZE = 40f;
  protected PVector size = new PVector(OBJECTSIZE, OBJECTSIZE);
  protected boolean density = true;
  protected boolean loadInBack = false; //true to insert at the front of draw, so player doesn't get loaded behind tiles
  protected boolean atomCollision = false; //do we collide with atoms themselves?

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

    //make sure the object cant get brighter than max (255)
    lightningAmount = constrain(lightningAmount, 0, 255);
  }

  // check if this object is in camera view
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

  void destroyed(){ //this is what you make a child proc from in-case you want to do something special on deletion
      objectList.remove(this);

      return;
  }

  void specialAdd(){ //add to certain lists

    if(loadInBack){
      objectList.add(0, this);
    }
    else{
      objectList.add(this); 
    }
    
    return;
  }

  boolean canMine(){ //could be useful for attacking
    return false;
  }

  void takeDamage(int damageTaken){

  }

  void pushed(Atom atom, float x, float y){ //we got pushed by an atom

  }
}