class Atom {
  PVector position = new PVector(100, 300);
  PVector size = new PVector(40, 40);
  PVector velocity = new PVector();
  PVector acceleration = new PVector();
  color atomColor = color(255, 0, 0);
  float atomSpeed = 2f;
  float jumpForce = 20f;
  boolean isGrounded, isMiningDown, isMiningLeft, isMiningRight;

  void handle(){
    prepareMovement();
    isGrounded = false;
    
    if(checkCollision()){
      velocity.y = 0; //stop moving
      isGrounded = true;
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

    position.x = constrain(position.x, 0, tilesHorizontal * tileWidth + 10);
	}

  boolean isGrounded(){
    return isGrounded;
  }

  void addForce(PVector forceToAdd){ //amount of pixels we move
    acceleration.add(forceToAdd);
  }
  
  boolean checkCollision(){
    for(Tile tile : getSurroundingTiles(int(position.x), int(position.y))){
      if(!tile.density){
        continue;
      }

      collisionDebug(tile);

      if(CollisionHelper.rectRect(position.x + velocity.x, position.y + velocity.y, size.x, size.y, tile.position.x, tile.position.y, tileWidth, tileHeight)){
        
        if(isMiningDown){
          tile.takeDamage(1);
        }

        return true;
      }
    }
    return false;
  }

  private void collisionDebug(Tile tile) {
    fill(255, 0, 0);
    rect(tile.position.x, tile.position.y, tileWidth, tileHeight);
  }
}
