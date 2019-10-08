class Player extends Mob{

  void handle(){
    super.handle();

    if(keys[LEFT]){
      user.addForce(new PVector(-atomSpeed, 0));
    }

    if(keys[UP] && super.isGrounded()){
      user.addForce(new PVector(0, -jumpForce));
    }

    //if(keys[DOWN]){
    //  user.addForce(new PVector(0, atomSpeed));
    //}

    if(keys[RIGHT]){
      user.addForce(new PVector(atomSpeed, 0));
    }
  }
}
