class Item extends PickUp{
  int throwSpeed = 50; //throw speed, for when you use it

  Mob thrower; //wheover threw us, if we're even throwable

  Item(){
    image = ResourceManager.getImage("DiamondPickUp"); 
  }

  boolean canCollideWith(BaseObject baseObject){
    if(baseObject == thrower){ //lets not instantly collide with whoever threw us 
      return false; 
    }

    return super.canCollideWith(baseObject);
  }

  void pickedUp(Mob mob){
    if(mob.canAddToInventory(this)){
      mob.addToInventory(this);
    }
  }

  void onUse(Mob mob){

    mob.removeFromInventory(this);
    int direction = 0;

    if(mob.isMiningLeft){
      direction = LEFT;
    }
    else if(mob.isMiningRight){
      direction = RIGHT;
    }
    if(mob.isMiningUp){
      direction = UP;
    }
    if(mob.isMiningDown){
      direction = DOWN;
    }

    throwItem(mob, direction);
    return;
  }

  void throwItem(Mob mob, int direction){ //took me 10 minutes of debugging to discover you cant use throw as func name
    moveTo(mob.position);
    switch(direction){
        case UP:
          velocity.set(0, -throwSpeed);
          break;
        case DOWN:
          velocity.set(0, throwSpeed);
          break;
        case LEFT:
          velocity.set(-throwSpeed, 0);
          break;
        case RIGHT:
          velocity.set(throwSpeed, 0);
          break;
    }

    canTake = false;
    thrower = mob;
  }

  void takeDamage(float damageTaken){
    super.takeDamage(damageTaken);
  }
}