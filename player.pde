class Player extends Mob {

  PVector spawnPosition = new PVector(1200, 500);
  int score = 0;

  public Player(){
    image = ResourceManager.getImage("player");
    // savedTime = second();
    // isHurt = false;
    position = spawnPosition;
  }

  void update(World world) {
    if (Globals.gamePaused) {  
      return;
    }
    
    super.update(world);
    doPlayerMovement();

    if (this.currentHealth == 0){
      Globals.currentGameState = Globals.gameState.gameOver;
    }
  }
  
  void doPlayerMovement() {
    if (keys[UP] && isGrounded()) {
      addForce(new PVector(0, -jumpForce));
    }

    if (keys[DOWN]) {
      isMiningDown = true;
    } else {
      isMiningDown = false;
    }

    if (keys[LEFT]) {
      addForce(new PVector(-speed, 0));
      isMiningLeft = true;
    } else {
      isMiningLeft = false;
    }

    if (keys[RIGHT]) {
      addForce(new PVector(speed, 0));
      isMiningRight = true;
    } else {
      isMiningRight = false;
    }
  }

  void addScore(int amount){
    score += amount;
  }
}
