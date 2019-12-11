class EnemyGhost extends Enemy {

  EnemyGhost(PVector spawnPos) {
    super(spawnPos);
    image = ResourceManager.getImage("GhostEnemy");
    setupLightSource(this, 125f, 1f);
    setMaxHp(1000);

    //Choose a random move direction
    int chooseSpeed = int(random(2));
    if (chooseSpeed == 1) this.walkLeft = true;

    //Disable gravity and collsion so that this enemy acts like a ghost
    collisionEnabled = false;
    gravityForce = 0;
    canSwim = false;
  }
}
