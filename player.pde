class Player extends Mob {

  float hurtTimer = 1f;
  float savedTime;
  boolean isHurt;

  public Player(){
    image = ResourceManager.getImage("player");
    savedTime = second();
    isHurt = false;
  }

  void update(World world) {
    if (Globals.gamePaused) {  
      return;
    }
    
    super.update(world);
    doPlayerMovement();

    if (isHurt == true) {
      float passedTime = second() - savedTime;
      if (passedTime > hurtTimer) {
        savedTime = second();
        isHurt = false;
      }
    }

    if (this.totalHealth == 0) Globals.currentGameState = Globals.gameState.gameOver;
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
      addForce(new PVector(-atomSpeed, 0));
      isMiningLeft = true;
    } else {
      isMiningLeft = false;
    }

    if (keys[RIGHT]) {
      addForce(new PVector(atomSpeed, 0));
      isMiningRight = true;
    } else {
      isMiningRight = false;
    }
  }

  public void playerHurt() {
    if (isHurt == false) {
      isHurt = true;
      this.totalHealth--;
    }
  }
}
