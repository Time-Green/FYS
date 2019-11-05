class Enemy extends Mob {

  public Enemy() {

    speed = 5;

    position = new PVector(1000, 500);
    velocity = new PVector(-speed, 0);
    
    //set dragfactors to 1 so we dont slow down by drag
    groundedDragFactor = 1f;
    aerialDragFactor = 1f;
  }

  void specialAdd(){
    mobList.add(this);
  }

  void specialDestroy(){
    mobList.remove(this);
  }

  void update(){

    if (Globals.gamePaused) {
      return;
    }

    super.update();

    handleCollision();

    //Can you please stop removing this bool from this script please?
    if (walkLeft) {
      velocity = new PVector(-speed, 0);
      flipSpriteHorizontal = false;
    } else {
      velocity = new PVector(speed, 0);
      flipSpriteHorizontal = true;      
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
