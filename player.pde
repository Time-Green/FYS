class Player extends Mob{
  float playerSpeed = 10f;

  void process(){
    super.process();

    if(keys[LEFT]){
      user.position.x -= playerSpeed;
    }

    if(keys[UP]){
      user.position.y-= playerSpeed;
    }

    if(keys[DOWN]){
      user.position.y+=playerSpeed;
    }

    if(keys[RIGHT]){
      user.position.x+=playerSpeed;
    }
  }
}
