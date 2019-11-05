class Atom extends BaseObject{
  //Vectors
  protected PVector velocity = new PVector();
  protected PVector acceleration = new PVector();

  //Movement
  protected float speed = 1f;
  protected float jumpForce = 18f;
  protected float gravityForce = 1f;
  protected float groundedDragFactor = 0.95f;
  protected float aerialDragFactor = 0.95f;
  protected float breakForce = 0.99f;

  //Bools
  protected boolean isGrounded;
  protected boolean isMiningDown, isMiningLeft, isMiningRight;
  protected boolean collisionEnabled = true;
  protected boolean walkLeft;
  protected boolean worldBorderCheck = true;
  protected boolean flipSpriteHorizontal;
  protected boolean flipSpriteVertical;

  //Tiles
  protected int miningcolor = #DC143C;
  protected PImage image;

  Atom(){
    PVector size = new PVector(40,40);
  }
  void specialAdd(){
    atomList.add(this);
  }

  void specialDestroy(){
    atomList.remove(this);
  }

  void update(){
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
        for(BaseObject object : colliders){

          if(isMiningDown){
            attemptMine(object);
          }

        }  
      }

      if(velocity.x < 0){
        colliders = checkCollision(world, min(velocity.x, 0), 0);

        if(colliders.size() != 0){ //left
          velocity.x = 0;
          walkLeft = !walkLeft;

          for(BaseObject object : colliders){
            if(isMiningLeft){
              attemptMine(object);
            }
          }
        }
      }
      else if(velocity.x > 0){
        colliders = checkCollision(world, max(velocity.x, 0), 0);
        if(colliders.size() != 0){ //right
          velocity.x = 0;
          walkLeft =!walkLeft;

          for(BaseObject object : colliders){
            if(isMiningRight){
              attemptMine(object);
            }
          }
        }     
      }
    }

    handleMovement(world);
  }

  void draw(){
    pushMatrix();

    translate(position.x, position.y);

    if(!flipSpriteHorizontal && !flipSpriteVertical){
      scale(1, 1);
      image(image, 0, 0, size.x, size.y);
    }else if(flipSpriteHorizontal && !flipSpriteVertical){
      scale(-1, 1);
      image(image, -size.x, 0, size.x, size.y);
    }else if(!flipSpriteHorizontal && flipSpriteVertical){
      scale(1, -1);
      image(image, 0, -size.y, size.x, size.y);
    }else if(flipSpriteHorizontal && flipSpriteVertical){
      scale(-1, -1);
      image(image, -size.x, -size.y, size.x, size.y);
    }

    popMatrix();
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

    if(worldBorderCheck){
      position.x = constrain(position.x, 0, world.getWidth() + 10);
    }
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
    ArrayList<BaseObject> colliders = new ArrayList<BaseObject>(); 
    ArrayList<BaseObject> potentialColliders = new ArrayList<BaseObject>();

    potentialColliders.addAll(world.getSurroundingTiles(int(position.x), int(position.y), this));
    potentialColliders.addAll(atomList);
    
    for (BaseObject object : potentialColliders){

      if(!object.density){
        continue;
      }

      //debugCollision(object);

      if(CollisionHelper.rectRect(position.x + maybeX, position.y + maybeY, size.x, size.y, object.position.x, object.position.y, tileWidth, tileHeight)){
        colliders.add(object);      
      }
    }

    return colliders;
  }

  private void debugCollision(BaseObject object){
    fill(miningcolor,100);
    rect(object.position.x, object.position.y, tileWidth, tileHeight);
  }

  float getDepth(){
    return position.y;
  }

  void attemptMine(BaseObject object){
    return;
  }
}
