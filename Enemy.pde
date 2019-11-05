class Enemy extends Mob {

  public Enemy() {

    speed = 5;

    position = new PVector(1000, 500);
    velocity = new PVector(-speed, 0);
    
    //set dragfactors to 1 so we dont slow down by drag
    groundedDragFactor = 1f;
    aerialDragFactor = 1f;
  }

  void update(World world){

    if (Globals.gamePaused) {
      return;
    }

    super.update(world);

    handleCollision();

    //Can you please stop removing this bool from this script please?
    if (!walkLeft) {
      velocity = new PVector(speed, 0);
      flipSpriteHorizontal = true;
    } else {
      velocity = new PVector(-speed, 0);
      flipSpriteHorizontal = false;
    }

    if (position.x < 10) walkLeft = false;
    if (position.x > world.getWidth() - 10) walkLeft = true;

  }

  private void handleCollision(){
    if (CollisionHelper.rectRect(position, size, player.position, player.size)){
      player.takeDamage(getAttackPower());
    }
  }
}
