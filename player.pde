class Player extends Mob{
  float playerSpeed = 10f;

  void process(){
    super.process();

    if(keys[LEFT]){
      user.move(-int(playerSpeed), 0);
    }

    if(keys[UP]){
      user.move(0, -int(playerSpeed));
    }

    if(keys[DOWN]){
      user.move(0, int(playerSpeed));
    }

    if(keys[RIGHT]){
      user.move(int(playerSpeed), 0);
    }
  }
}
