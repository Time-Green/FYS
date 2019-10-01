class Player extends Mob{
  int playerX = 200;
  int playerY = 200;
  int playerWidth = 50;
  int playerHeight = 100;
  void process(){
    rect(playerX,playerY,playerWidth,playerHeight);
  }
}
