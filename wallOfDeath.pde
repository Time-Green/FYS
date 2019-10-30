class WallOfDeath extends Atom {

  private float moveSpeed = 1f;
  private float wallHeight = 100;
  private float wallY = -100;

  color wallColor = #FF8C33;
  
  //for debug only
  final boolean ENABLEPLAYERCOLLISION = false;

  WallOfDeath(float wallWidth){
    gravityForce = 0f;
    groundedDragFactor = 1f;
    collisionEnabled = false;
    size = new PVector(wallWidth, wallHeight);
    position = new PVector(0, wallY);
    velocity = new PVector(0, moveSpeed);
  }
  
  void update(World world){
    
    velocity.y = player.getDepth() / 1000; // velocity of the WoD increases as the player digs deeper (temporary)
    
    if (Globals.gamePaused){
      return;
    }

    if(ENABLEPLAYERCOLLISION){
      checkPlayerCollision();
    }

    super.update(world);
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
      Globals.currentGameState = Globals.gameState.gameOver;
      
    }
  }
}
