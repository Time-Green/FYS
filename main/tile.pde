class Tile {
  int tileX;
  int tileY;
  
  int tileXWhole, tileYWhole; //tileX divided by the amount of tiles. 
  
  boolean tileDestroy;
  boolean density = true;
  
  ArrayList<Atom> contents = new ArrayList<Atom>(); //alle Atom's die op die tile staan
  
  Tile(int x , int y){
    tileX = x;
    tileY = y;
    tileXWhole = tileX * tilesHorizontal;
    tileYWhole = tileY * tilesVertical;
  }
  
  void process(){
    draw();
  }
  void draw(){
    rect(tileX,tileY,tileWidth,tileHeight);
  }
}

class openTile extends Tile{
  
  openTile(int x, int y){
    super(x, y);
    density = false;
  }
  void draw(){
    return;
  }
}
