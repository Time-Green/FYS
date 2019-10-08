class Player extends Mob{
  

  void process(){
    super.process();

    if(keys[LEFT]){
      user.move(-int(atomSpeed), 0);
    }

    if(keys[UP]){
      user.move(0, -int(atomSpeed));
    }

    if(keys[DOWN]){
      user.move(0, int(atomSpeed));
    }

    if(keys[RIGHT]){
      user.move(int(atomSpeed), 0);
    }
  }
}
