class Tile {
  PVector position = new PVector();
  PVector positionWhole = new PVector(); //same as position, but pixels instead of complete tiles

  boolean tileDestroy;
  boolean density = true;
  
  ArrayList<Atom> contents = new ArrayList<Atom>(); //all Atoms on that specific tile
  
  Tile(int x , int y){
    position.x = x * tileWidth;
    position.y = y * tileHeight;
    
    positionWhole.x = x;
    positionWhole.y = y;
  }
  
  void process(){
    draw();
  }

  void draw(){
    rect(position.x, position.y, tileWidth, tileHeight);
  }
}
