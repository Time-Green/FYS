class Tile {
  PVector position = new PVector();
  PVector positionWhole = new PVector(); //zelfde als position, maar in plaats van pixels complete tiles

  boolean tileDestroy;
  boolean density = true;
  
  ArrayList<Atom> contents = new ArrayList<Atom>(); //alle Atom's die op die tile staan
  
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

class openTile extends Tile{
  
  openTile(int x, int y){
    super(x, y);
    density = false;
  }

  void draw(){
    return;
  }
}
