class EnemyWalker extends Enemy {

  EnemyWalker(PVector spawnPos){
    super(spawnPos);

    image = ResourceManager.getImage("WalkEnemy");
  }
  
  void takeDamage(float damageTaken){
    super.takeDamage(damageTaken);
  }
}