class Atom {
  //Vectors
  PVector position;
  PVector size = new PVector(40, 40);
  //PVector scaleSize = new PVector(40,40);
  PVector velocity = new PVector();
  PVector acceleration = new PVector();

  //Movement
  float speed = 1f;
  float jumpForce = 18f;
  float gravityForce = 1f;
  float groundedDragFactor = 0.95f;
  float aerialDragFactor = 0.95f;
  float breakForce = 0.99f;

  //Bools
  boolean isGrounded;
  boolean isMiningDown, isMiningLeft, isMiningRight;
  boolean collisionEnabled = true;
  boolean walkLeft;

  //Tiles
  int miningcolor = #DC143C;
  PImage image;

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
            attemptMine(tile);
          }

        }  
      }

      if(velocity.x < 0){
        colliders = checkCollision(world, min(velocity.x, 0), 0);

        if(colliders.size() != 0){ //left
          velocity.x = 0;
          walkLeft = !walkLeft;

          for(Tile tile : colliders){
            if(isMiningLeft){
              attemptMine(tile);
            }
          }
        }
      }
      else if(velocity.x > 0){
        colliders = checkCollision(world, max(velocity.x, 0), 0);
        if(colliders.size() != 0){ //right
          velocity.x = 0;
          walkLeft =!walkLeft;

          for(Tile tile : colliders){
            if(isMiningRight){
              attemptMine(tile);
            }
          }
        }     
      }
    }

    handleMovement(world);
  }

  void draw(){
    //pushMatrix();
    //scale(scaleSize.x,scaleSize.y);
    image(image, position.x, position.y, size.x, size.y);
    //popMatrix();
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

  private void handleMovement(World world){
    position.add(velocity);

    position.x = constrain(position.x, 0, world.getWidth() + 10);
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

      //debugCollision(tile);

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

  void attemptMine(Tile tile){
    return;
  }
}
