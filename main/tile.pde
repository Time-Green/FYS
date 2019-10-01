class Tile {
  int tileX = 200;
  int tileY = 200;
  int tileWidth = 50;
  int tileHeight = 50;
  
  Tile(int x , int y){
    tileX = x;
    tileY = y;
  }
  
  void process(){
    rect(tileX,tileY,tileWidth,tileHeight);
  }
}
