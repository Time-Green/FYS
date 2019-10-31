  enum EnemyType {//This has to go ouside the class because it has to
    normal,
    digger,
    bomb,
    ghost
  }

class Enemy extends Mob {
  EnemyType myType;

  public Enemy(){
    this.image = ResourceManager.getImage("TestEnemy");

    this.speed = 5;

    this.position = new PVector(1000, 500);
    this.velocity = new PVector(-speed, 0);
    
    //set dragfactors to 1 so we dont slow down by drag
    groundedDragFactor = 1f;
    aerialDragFactor = 1f;

    int typeSelect = (int)random(0, 4);
    
    //Give this enemy their type based on the result of typeSelect
    switch (typeSelect) {
      default :
        //Do nothing in case something goes wrong
        println("WARNING: EnemyType not found!");
      return;
      case 0 :
        myType = EnemyType.normal;
      break;
      case 1 :
        myType = EnemyType.digger;
      break;
      case 2 :
        myType = EnemyType.bomb;
      break;
      case 3 :
        myType = EnemyType.ghost;
      break;
    }
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
