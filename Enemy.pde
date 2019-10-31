  enum EnemyType {//This has to go ouside the class because it has to
    normal,
    digger,
    bomb,
    ghost
  }

class Enemy extends Mob {
  EnemyType myType;

  public Enemy(){
    image = ResourceManager.getImage("TestEnemy");

    speed = 5;

    position = new PVector(1000, 500);
    velocity = new PVector(-speed, 0);
    
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

    if (position.x < 10) walkLeft = false;
    if (position.x > world.getWidth() - 10) walkLeft = true;
  }

  private void handleCollision(){
    if (CollisionHelper.rectRect(position, size, player.position, player.size)){
      player.takeDamage(getAttackPower());
    }
  }

  private void handleMovement(World world){

    if(!walkLeft) velocity = new PVector(speed, 0);

    if(walkLeft)  velocity = new PVector(-speed, 0);
  }
}
