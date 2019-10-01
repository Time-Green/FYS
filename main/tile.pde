class Tile {
  int tileX;
  int tileY;
  
  int tileXWhole, tileYWhole; //tileX divided by the amount of tiles. 
  
  boolean tileDestroy;
  
  Tile(int x , int y){
    tileX = x;
    tileY = y;
    tileXWhole = tileX * tilesHorizontal;
    tileYWhole = tileY * tilesVertical;
  }
  
  void process(){
    rect(tileX,tileY,tileWidth,tileHeight);
  }
}
