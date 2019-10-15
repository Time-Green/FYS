class WallOfDeath extends Atom{

  private float moveSpeed = 1f;
  private float wallHeight = 100;
  private float wallY = -100;

  color wallColor = #FF8C33;

  WallOfDeath(float wallWidth) {
    gravityForce = 0f;
    dragFactor = 1f;
    collisionEnabled = false;
    size = new PVector(wallWidth, wallHeight);
    position = new PVector(0, wallY);
    velocity = new PVector(0, moveSpeed);
  }
  
  // If the WoD hits the player, the game is paused. 
  void checkIfPlayerHit(Mob player){
    if(CollisionHelper.rectRect(position, size, player.position, player.size)){
        Globals.gamePaused = true;  
    }
  }

  void update() {
    if(Globals.gamePaused){
      return; 
    }    
    super.update();
  }

  void draw() {
    fill(wallColor);
    rect(position.x, position.y, size.x, size.y);
    fill(255);
  }
}
