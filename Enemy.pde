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
    this.image = ResourceManager.getImage("TestEnemy");

    this.position = new PVector(1000, 500);

    // this.mySpeed = random(0, 1);
    // this.walkLeft = randomBool();

    int typeSelect = (int)random(0, 4);
    //Give this enemy their type based on the result of typeSelect
    switch (typeSelect) {
      default :
        //Do nothing in case something goes wrong
      return;
      case 0 :
        this.myType = enemyType.normal;
      break;
      case 1 :
        this.myType = enemyType.digger;
      break;
      case 2 :
        this.myType = enemyType.bomb;
      break;
      case 3 :
        this.myType = enemyType.ghost;
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
    if (this.position.x <= 100.0f) this.walkLeft = !this.walkLeft;
    println("position.x: "+position.x);
    // world
  }

  private void enemyCollision(){
    if (CollisionHelper.rectRect(this.position, this.size, player.position, player.size))
      player.takeDamage(getDamage());
  }

  private void enemyMovement() {
    if (this.walkLeft) this.speed = this.mySpeed;
    else this.speed = -this.mySpeed;
    addForce(new PVector(this.speed, 0));
  }
}
