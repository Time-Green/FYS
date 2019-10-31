class Enemy extends Mob {

  public Enemy(){

    this.speed = 5;

    this.position = new PVector(1000, 500);
    this.velocity = new PVector(-speed, 0);
    
    //set dragfactors to 1 so we dont slow down by drag
    groundedDragFactor = 1f;
    aerialDragFactor = 1f;
  }

  void update(World world){

    if (Globals.gamePaused){
      return;
    }

    super.update(world);

    handleCollision();
    handleMovement(world);

    if (this.position.x < 10) this.walkLeft = false;
    if (this.position.x > world.getWidth() - 10) this.walkLeft = true;
  }

  private void handleCollision(){
    if (CollisionHelper.rectRect(this.position, this.size, player.position, player.size)){
      player.takeDamage(getAttackPower());
    }
  }

  private void handleMovement(World world){

    if(!this.walkLeft) this.velocity = new PVector(speed, 0);

    if(this.walkLeft)  this.velocity = new PVector(-speed, 0);
  }
}
