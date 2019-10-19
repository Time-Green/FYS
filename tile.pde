class Tile {
  PVector position = new PVector();
  PVector positionWhole = new PVector(); //same as position, but pixels instead of complete tiles

  boolean destroyed;
  boolean isSolid = true;

  float hp = 4;

  PImage image;

  ArrayList<Atom> contents = new ArrayList<Atom>(); //all Atoms on that specific tile

  Tile(int x, int y) {
    position.x = x * tileWidth;
    position.y = y * tileHeight;

    positionWhole.x = x;
    positionWhole.y = y;

    if(position.y == 550){
      image = ResourceManager.getImage("GrassBlock");
    }else if(position.y > 550 && position.y <= 1000){
      image = ResourceManager.getImage("DirtBlock");
    }else{
      image = ResourceManager.getImage("StoneBlock");
    }
  }

  void update() {
  }

  void draw() {
    if (!destroyed) {
      //rect(position.x, position.y, tileWidth, tileHeight);
      image(image, position.x, position.y, tileWidth, tileHeight);
    }
  }

  void takeDamage(float damageTaken) {
    hp -= damageTaken;

    if (hp <= 0) {
      destroy();
    }
  }

  private void destroy() {
    destroyed = true;
    isSolid = false;
  }
}
