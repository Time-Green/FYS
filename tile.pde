class Tile {
  PVector position = new PVector();
  PVector positionWhole = new PVector(); //same as position, but pixels instead of complete tiles

  boolean destroyed;
  boolean density = true;

  float hp = 1;
  
  ArrayList<Atom> contents = new ArrayList<Atom>(); //all Atoms on that specific tile
  
  Tile(int x , int y){
    position.x = x * tileWidth;
    position.y = y * tileHeight;
    
    positionWhole.x = x;
    positionWhole.y = y;
  }
  
  void handle(){
    
  }

  void draw(){
    if(!destroyed){
      rect(position.x, position.y, tileWidth, tileHeight);
    }
  }

  void takeDamage(float damageTaken){
    hp -= damageTaken;

    if(hp <= 0){
      destroy();
    }
  }

  private void destroy() {
    destroyed = true;
    density = false;
  }
}
