class Obstacle extends Movable{

  Obstacle(){
    movableCollision = true;
    anchored = false;
  }

  void takeDamage(float damageTaken){
    super.takeDamage(damageTaken);
  }
}
