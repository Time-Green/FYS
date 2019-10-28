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
           
      ArrayList<Tile> coliders = new ArrayList<Tile>(); 
      
      coliders = checkCollision(world, 0, velocity.y);  
      if(coliders.size() != 0){ //up
        velocity.y = max(velocity.y, 0);
      }    
      
      if(coliders.size() != 0){ //down
        velocity.y = min(velocity.y, 0);
        isGrounded = true;       
        if(isMiningDown){
       //   tile.takeDamage(1);  jonah - 28/10/19
        }
      }
      
      coliders = checkCollision(world, min(velocity.x, 0), 0);  
      if(coliders.size() != 0){ //left
        velocity.x = 0;
      }
      
      checkCollision(world, max(velocity.x, 0), 0);
      if(coliders.size() != 0){ //right
      for(Tile tile : coliders){
        if(isMiningRight){
          tile.takeDamage(1); 
        }
      }  
        velocity.x = 0;
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
    ArrayList<Tile> coliders = new ArrayList<Tile>(); 
    
    for (Tile tile : world.getSurroundingTiles(int(position.x), int(position.y), this)){

      if(!tile.isSolid){
        continue;
      }

      debugCollision(tile);

      if(CollisionHelper.rectRect(position.x + maybeX, position.y + maybeY, size.x, size.y, tile.position.x, tile.position.y, tileWidth, tileHeight)){

        //if(isMiningDown){
        //  tile.takeDamage(1);
        //} 
        //else if(isMiningLeft){
        //   tile.takeDamage(1);
        //} 
                

        coliders.add(tile);      
      }
    }

    return coliders;
  }

  private void debugCollision(Tile tile){
    fill(miningcolor,100);
    rect(tile.position.x, tile.position.y, tileWidth, tileHeight);
  }

  int getDepth(){
    return int(position.y);
  }
}
