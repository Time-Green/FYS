class Player extends Mob { 

  void update() {
    if (Globals.gamePaused) {  
      return;
    }
    super.update();

    if (keys[UP] && isGrounded()) {
      user.addForce(new PVector(0, -jumpForce));
    }

    if (keys[DOWN]) {
      isMiningDown = true;
    } else {
      isMiningDown = false;
    }

    if (keys[LEFT]) {
      user.addForce(new PVector(-atomSpeed, 0));
      isMiningLeft = true;
    } else {
      isMiningLeft = false;
    }

    if (keys[RIGHT]) {
      user.addForce(new PVector(atomSpeed, 0));
      isMiningRight = true;
    } else {
      isMiningRight = false;
    }
  }
}
