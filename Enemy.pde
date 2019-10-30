  enum enemyType {//This has to go ouside the class because it has to
    normal,
    digger,
    bomb,
    ghost
  }

class Enemy extends Mob {

  float mySpeed = 1f;

  enemyType myType;

  public Enemy(){
    image = ResourceManager.getImage("TestEnemy");

    position = new PVector(1000, 500);

    // this.mySpeed = random(0, 1);
    // this.walkLeft = randomBool();

    int typeSelect = (int)random(0, 4);
    //Give this enemy their type based on the result of typeSelect
    switch (typeSelect) {
      default :
        //Do nothing in case something goes wrong
      return;
      case 0 :
        myType = enemyType.normal;
      break;
      case 1 :
        myType = enemyType.digger;
      break;
      case 2 :
        myType = enemyType.bomb;
      break;
      case 3 :
        myType = enemyType.ghost;
      break;
    }
  }

  void update(World world){

    if (Globals.gamePaused){
      return;
    }

    super.update(world);

    enemyCollision();
    enemyMovement();

    //Todo: get this to work
    if (position.x <= 100.0f) walkLeft = !walkLeft;
    println("position.x: "+position.x);
    // world
  }

  private void enemyCollision(){
    if (CollisionHelper.rectRect(position, size, player.position, player.size))
      player.takeDamage(getAttackPower());
  }

  private void enemyMovement() {
    if (walkLeft) speed = mySpeed;
    else speed = -mySpeed;
    addForce(new PVector(speed, 0));
  }
}
