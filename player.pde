class Player extends Mob { 

  int score = 0;

  public Player(){
    image = ResourceManager.getImage("player");
  }

  void update(World world) {
    if (Globals.gamePaused) {  
      return;
    }
    
    super.update(world);
    doPlayerMovement();
  }
  
  void doPlayerMovement(){
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

  void addScore(int amount){
    score += amount;
  }
}
