class WallOfDeath extends Atom {

  private float moveSpeed = 0;
  private float wallHeight = 100;
  private float wallY = -100;

  color wallColor = #FF8C33;

  WallOfDeath(float wallWidth){
    gravityForce = 0f;
    groundedDragFactor = 1f;
    collisionEnabled = false;
    size = new PVector(wallWidth, wallHeight);
    position = new PVector(0, wallY);
    velocity = new PVector(0, moveSpeed);
  }

  void update(World world){
    if (Globals.gamePaused){
      return;
    }

    checkPlayerCollision();

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
