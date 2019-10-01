class Player extends Mob{
  void process(){
    if(keys[LEFT]){
      user.atomX--;
    }
    if(keys[UP]){
      user.atomY--;
    }
    
     if(keys[DOWN]){
      user.atomY++;
    }
    if(keys[RIGHT]){
      user.atomX++;
    }
  }
}
