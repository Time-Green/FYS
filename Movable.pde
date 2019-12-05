class Movable extends BaseObject{
  //Vectors
  protected PVector velocity = new PVector();
  protected PVector acceleration = new PVector();
  protected PVector maxVelocity = new PVector(40, 40);

  //Movement
  protected float speed = 1f;
  protected float jumpForce = 18f;
  protected float gravityForce = 1f;
  protected float groundedDragFactor = 0.90f;
  protected float slipperiness = 1; //stolen from tile to get slipperiness. set to 1 after being used
  protected float aerialDragFactor = 0.95f;
  protected float breakForce = 0.99f;
  protected float pushCoefficient = 1; //the higher, the easier

  //Bools
  protected boolean isGrounded;
  protected boolean isMiningDown, isMiningUp, isMiningLeft, isMiningRight;
  protected boolean collisionEnabled = true;
  protected boolean walkLeft;
  protected boolean worldBorderCheck = true;
  protected boolean flipSpriteHorizontal;
  protected boolean flipSpriteVertical;
  protected boolean anchored = false; //true if we are completely immovable
  protected boolean anchoredHorizontaly = false;

  //Tiles
  protected int miningcolor = #DC143C;
  protected PImage image;

  Movable(){
    super(); 	
  }

  void specialAdd(){
    super.specialAdd();
    movableList.add(this);
  }

  void destroyed(){
    super.destroyed();
    movableList.remove(this);
  }

  void update(){
    super.update();
    if(suspended){
      return;
    }

    prepareMovement();
    doCollision();
    handleMovement(world);
  }

  void doCollision(){
    if(!collisionEnabled){
        return;
    }
    isGrounded = false;
    ArrayList<Tile> colliders = new ArrayList<Tile>();

    colliders = checkCollision(world, 0, min(velocity.y, 0));
      
    if(colliders.size() != 0){ //up
        
      for(BaseObject object : colliders){
        object.pushed(this, 0, velocity.y); 

        if(isMiningUp) {
          attemptMine(object);
        }

      } 
        
      velocity.y = max(velocity.y, 0);
    }
      
    colliders = checkCollision(world, 0, max(velocity.y, 0));

    if(colliders.size() != 0){ //down
        
      isGrounded = true;    

      for(BaseObject object : colliders){
        object.pushed(this, 0, velocity.y);

        if(isMiningDown){
          attemptMine(object);
        }

        if(object instanceof Tile){
          Tile tile = (Tile) object;
          slipperiness = tile.slipperiness;
        }

      }

      velocity.y = min(velocity.y, 0);
    }

    if(velocity.x < 0){
      colliders = checkCollision(world, min(velocity.x, 0), 0);

      if(colliders.size() != 0){ //left
          
        walkLeft = !walkLeft;

        for(BaseObject object : colliders){
          object.pushed(this, velocity.x, 0);

          if(isMiningLeft){
            attemptMine(object);
          }

        }

        velocity.x = 0;
      }
    }

    else if(velocity.x > 0){

      colliders = checkCollision(world, max(velocity.x, 0), 0);

      if(colliders.size() != 0){ //right
          
        walkLeft =!walkLeft;

        for(BaseObject object : colliders){
          object.pushed(this, velocity.x, 0);

          if(isMiningRight){
            attemptMine(object);
          }

        }
        velocity.x = 0;  
      }   
    }
  }

  void draw(){
    if(!inCameraView() || suspended){
      return;
    }
    
    super.draw();

    pushMatrix();

    translate(position.x, position.y);

    tint(lightningAmount);

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

    tint(255);

    popMatrix();
  }

  private void prepareMovement(){
    //gravity
    acceleration.add(new PVector(0, gravityForce));

    velocity.add(acceleration);
    velocity.limit(20);

    acceleration.mult(0);

    if(velocity.x > maxVelocity.x){
      velocity.x = maxVelocity.x;
    }
    if(velocity.y > maxVelocity.y){
      velocity.y = maxVelocity.y;
    }

    if(isGrounded()){
      velocity.x *= min(groundedDragFactor * slipperiness, 1); //drag
    }else{
      velocity.x *= aerialDragFactor; //drag but in the air
    }
    slipperiness = 1;
  }

  private void handleMovement(World world){
    if(!anchored){

      if(!anchoredHorizontaly){
        position.add(velocity);
      }else{
        position.add(new PVector(0, velocity.y));
      }
      
    }

    if(worldBorderCheck){
      position.x = constrain(position.x, 0, world.getWidth() + 10);
    }
  }

  boolean isGrounded(){
    return isGrounded;
  }

  void addForce(PVector forceToAdd){ //amount of pixels we move
    if(!anchored){
      acceleration.add(forceToAdd);
    }
  }

  void setForce(PVector newForce){
    if(!anchored){
      acceleration = newForce;
    }
  }

  ArrayList checkCollision(World world, float maybeX, float maybeY){
    ArrayList<BaseObject> colliders = new ArrayList<BaseObject>(); 
    ArrayList<BaseObject> potentialColliders = new ArrayList<BaseObject>();

    potentialColliders.addAll(world.getSurroundingTiles(position.x, position.y, this));
    potentialColliders.addAll(movableList);
    
    for (BaseObject object : potentialColliders){

      if(object == this){
        continue;
      }

      if(CollisionHelper.rectRect(position.x + maybeX, position.y + maybeY, size.x, size.y, object.position.x, object.position.y, object.size.x, object.size.y)){
        if(!object.canCollideWith(this)){
          continue;
        }
        object.collidedWith(this);
        collidedWith(object);
        colliders.add(object);      
      }
    }

    return colliders;
  }

  int getDepth(){
    return int(position.y / tileSize);
  }

  void attemptMine(BaseObject object){
    return;
  }

  void pushed(Movable movable, float x, float y){ //use x and y, because whoever calls this needs fine controle over the directions that actually push, and this is easiest
    velocity.add(x * pushCoefficient, y * pushCoefficient);
  }

  boolean canCollideWith(BaseObject object){
    if(!density){
      return false;
    }
    
    return movableCollision || object.movableCollision;
  }

  public boolean canPlayerInteract(){ //looks better than instanceof
    return false;
  }
}
