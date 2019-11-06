class Enemy extends Mob {

  public Enemy() {
    this.speed = 5f;

    this.position = new PVector(1000, 500);
    this.velocity = new PVector(-speed, 0);
    
    //set dragfactors to 1 so we dont slow down by drag
    this.groundedDragFactor = 1f;
    this.aerialDragFactor = 1f;
  }

  void specialAdd(){
    super.specialAdd();
    mobList.add(this);
  }

  void destroyed(){
    super.destroyed();
    mobList.remove(this);
  }

  void update(){

    if (Globals.gamePaused) {
      return;
    }

    super.update();

    handleCollision();

    //Can you please stop removing this bool from this script please?
    if (this.walkLeft) {
      this.velocity = new PVector(-speed, 0);
      //Flip the image if we are on the ground
      if(this.isGrounded) this.flipSpriteHorizontal = false;
    } else {
      this.velocity = new PVector(speed, 0);
      //Flip the image if we are on the ground
      if(this.isGrounded) this.flipSpriteHorizontal = true;      
    }

    if (position.x < 10) walkLeft = false;
    if (position.x > world.getWidth() - 10) walkLeft = true;

  }

  protected void handleCollision(){
    if (CollisionHelper.rectRect(position, size, player.position, player.size)){
      player.takeDamage(getAttackPower());
    }
  }
}
