class Player extends Mob{
  void process(){
    super.process();

    if(keys[LEFT]){
      user.position.x--;
    }

    if(keys[UP]){
      user.position.y--;
    }

    if(keys[DOWN]){
      user.position.y++;
    }

    if(keys[RIGHT]){
      user.position.x++;
    }
  }
}
