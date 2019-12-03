class EnemyGhost extends Enemy {

  EnemyGhost(PVector spawnPos){
    super(spawnPos);
    image = ResourceManager.getImage("GhostEnemy");
    setupLightSource(this, 125f, 1f);
    setMaxHp(1000);
    
    //Diable gravity and collsion so that this enemy acts like a ghost
    collisionEnabled = false;
    gravityForce = 0;
    
  }

}
