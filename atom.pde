class Atom {
  PVector position = new PVector(100, 300);
  PVector size = new PVector(40, 40);
  color atomColor = color(255, 0, 0);

  void process(){
    draw();
  }

  void draw(){
    fill(atomColor);
    rect(position.x, position.y, size.x, size.y); 
  }

  void move(int x, int y){ //amount of pixels we move
    if(checkCollision(x, y)){
      position.x += x;
      position.y += y;
    }
  }
  
  boolean checkCollision(int addX, int addY){
    for(Tile tile : tileList){
      if(!tile.density){
        continue;
      }
      if(CollisionHelper.rectRect(position.x + addX, position.y + addY, size.x, size.y, tile.position.x, tile.position.y, tileWidth, tileHeight)){
        return false;
      }
    }
    return true;
  }
}
