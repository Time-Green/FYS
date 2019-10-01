class Tile {
  int tileX;
  int tileY;
  boolean tileDestroy;
  
  Tile(int x , int y){
    tileX = x;
    tileY = y;
  }
  
  void process(){
    rect(tileX,tileY,tileWidth,tileHeight);
  }
}
