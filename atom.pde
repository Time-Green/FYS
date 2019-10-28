class Atom {
  PVector position;
  PVector startPosition = new PVector(1200, 500);
  PVector size = new PVector(40, 40);
  PVector velocity = new PVector();
  PVector acceleration = new PVector();
  float atomSpeed = 1f;
  float jumpForce = 18f;
  float gravityForce = 1f;
  float groundedDragFactor = 0.95f;
  float aerialDragFactor = 0.95f;
  float breakForce = 0.99f;
  boolean isGrounded, isMiningDown, isMiningLeft, isMiningRight;
  boolean collisionEnabled = true;
  int miningcolor = #DC143C;
  PImage image;

  Atom(){
    Prepare();
  }

  void Prepare(){
    position = startPosition;
  }

  void update(World world){
    prepareMovement();
    isGrounded = false;

    if(collisionEnabled){   
      ArrayList<Tile> colliders = new ArrayList<Tile>(); 
      
      colliders = checkCollision(world, 0, min(velocity.y, 0));
      
      if(colliders.size() != 0){ //up
        velocity.y = max(velocity.y, 0);
      }    
      
      colliders = checkCollision(world, 0, max(velocity.y, 0));

      if(colliders.size() != 0){ //down
        velocity.y = min(velocity.y, 0);
        isGrounded = true;       
        for(Tile tile : colliders){

          if(isMiningDown){
            tile.takeDamage(1); 
          }
        }  
      }

      if(velocity.x < 0){
        colliders = checkCollision(world, min(velocity.x, 0), 0);

        if(colliders.size() != 0){ //left
          velocity.x = 0;
          for(Tile tile : colliders){

            if(isMiningLeft){
              tile.takeDamage(1); 
            }
          }  
        }
      }
      else if(velocity.x > 0){
        colliders = checkCollision(world, max(velocity.x, 0), 0);
        if(colliders.size() != 0){ //right
          velocity.x = 0;
          for(Tile tile : colliders){
            if(isMiningRight){
              tile.takeDamage(1); 
            }
          }  
        }     
      }
    }

    handleMovement();
  }

  void draw(){
    image(image, position.x, position.y, size.x, size.y);
  }

  private void prepareMovement(){
    //gravity
    acceleration.add(new PVector(0, gravityForce));

    velocity.add(acceleration);
    acceleration.mult(0);

    if(isGrounded()){
      velocity.x *= groundedDragFactor; //drag
    }else{
      velocity.x *= aerialDragFactor; //drag but in the air
    }
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

  void setForce(PVector newForce){
    acceleration = newForce;
  }

  ArrayList checkCollision(World world, float maybeX, float maybeY){
    ArrayList<Tile> colliders = new ArrayList<Tile>(); 
    
    for (Tile tile : world.getSurroundingTiles(int(position.x), int(position.y), this)){

      if(!tile.isSolid){
        continue;
      }

      debugCollision(tile);

      if(CollisionHelper.rectRect(position.x + maybeX, position.y + maybeY, size.x, size.y, tile.position.x, tile.position.y, tileWidth, tileHeight)){
        colliders.add(tile);      
      }
    }

    return colliders;
  }

  private void debugCollision(Tile tile){
    fill(miningcolor,100);
    rect(tile.position.x, tile.position.y, tileWidth, tileHeight);
  }

  float getDepth(){
    return position.y;
  }
}
