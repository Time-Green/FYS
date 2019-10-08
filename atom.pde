class Atom {
  PVector position = new PVector(100, 300);
  PVector size = new PVector(40, 40);
  PVector velocity = new PVector();
  PVector acceleration = new PVector();
  color atomColor = color(255, 0, 0);
  float atomSpeed = 5f;

  void handle(){
    prepareMovement();

    if(checkCollision(velocity.x, velocity.y)){
      velocity.mult(0); //stop moving
    }

    handleMovement();
  }

  void draw(){
    fill(atomColor);
    rect(position.x, position.y, size.x, size.y); 
  }

  private void prepareMovement() {
    //gravity
    acceleration.add(new PVector(0, 1));

		velocity.add(acceleration);
    acceleration.mult(0);

		//velocity.limit(15); //max speed
		velocity.mult(0.95); //drag
  }

  private void handleMovement(){
		position.add(velocity);
	}

  void addForce(PVector forceToAdd){ //amount of pixels we move
    acceleration.add(forceToAdd);
  }
  
  boolean checkCollision(float addX, float addY){
    for(Tile tile : getSurroundingTiles(int(position.x), int(position.y))){
      if(!tile.density){
        continue;
      }

      if(CollisionHelper.rectRect(position.x + addX, position.y + addY, size.x, size.y, tile.position.x, tile.position.y, tileWidth, tileHeight)){
        return true;
      }
    }
    return false;
  }
}
