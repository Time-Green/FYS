class EnemyWalker extends Enemy {

  EnemyWalker() {
    image = ResourceManager.getImage("WalkEnemy");
  }
  
  void takeDamage(float damageTaken){
    super.takeDamage(damageTaken);
  }
}