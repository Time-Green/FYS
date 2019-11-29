class EnemyGhost extends Enemy {

  EnemyGhost(PVector spawnPos){
    super(spawnPos);

    image = ResourceManager.getImage("GhostEnemy");
    collisionEnabled = false;
    gravityForce = 0;
    position.set(1000, 2000);
    setupLightSource(this, 125f, 1f);
  }

  void takeDamage(float damageTaken){
    super.takeDamage(damageTaken);
  }
}
