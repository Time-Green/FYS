class WallOfDeath extends Atom {

  private float moveSpeed = 1f;
  private float wallHeight = 100;
  private float wallY = -100;

  private color wallColor = #FF8C33;

  private final int DESTROYTILESAFTER = 10; //destroys tiles permanently x tiles behind the WoD

  WallOfDeath(float wallWidth){

    name = "Wall of Death";

    position = new PVector(0, wallY);
    velocity = new PVector(0, moveSpeed);
    size = new PVector(wallWidth, wallHeight);

    //for debug only, Remove this line of code when puplishing
    collisionEnabled = false;

    //movement is not done with gravity but only with velocity
    gravityForce = 0f;
    groundedDragFactor = 1f;
  }
  
  void update(){

    if (Globals.gamePaused){
      return;
    }

  if(frameCount % 15 == 0){ 
    load(new Meteor(position.y)); 
 
  }

  super.update();

    velocity.y = player.getDepth() / 1000; // velocity of the WoD increases as the player digs deeper (temporary)
    
    //cleanUpTiles();
    cleanUpObjects();
  }

  void draw(){
    fill(wallColor);
    rect(position.x, position.y, size.x, size.y);
    fill(255);
  }

  // If the WoD hits the player, the game is paused. 
  private void checkPlayerCollision(){

    if (CollisionHelper.rectRect(position, size, player.position, player.size)){
      Globals.gamePaused = true;
      Globals.currentGameState = Globals.GameState.GameOver;
    }

  }

  private void cleanUpTiles(){
    int layer = int(world.getGridPosition(this).y - DESTROYTILESAFTER);

    //it's not time to destroy yet, because we just started
    if(layer < 0){
      return;
    }
    
    for(Tile tile : world.getLayer(layer)){
      delete(tile);
    }
  }

  private void cleanUpObjects(){

    for (BaseObject object : objectList) {
      
      //is the object above the wall of death..
      if(object.position.y < position.y - DESTROYTILESAFTER * tileHeight){

        //..and its not the player..
        if(object instanceof Player){
          continue;
        }

        //..https://www.youtube.com/watch?v=Kbx7m2qVVA0
        delete(object);
      }
    }
  }
}
