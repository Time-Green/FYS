class EnemyBomb extends Enemy {

  private float explosionRange = 80;
  
  private boolean isExploding = false;
  private float explosionTimer = 90f;
  private float explosionSize = 500;
  
  EnemyBomb(PVector spawnPos){
    super(spawnPos);
    
    image = ResourceManager.getImage("BombEnemy");
    this.speed = 2.5f;
  }

  void update() {
    super.update();

    if (isExploding) {

      this.speed = 0;
      explosionTimer--;

      if (explosionTimer <= 0) {

        load(new Explosion(position, explosionSize));
        float distance = dist(this.position.x, this.position.y, player.position.x, player.position.y);

        if (distance <= explosionRange){
            player.takeDamage(getAttackPower(true));
        }

        delete(this);
      }
    }
  }

  protected void handleCollision(){
    super.handleCollision();

    if (CollisionHelper.rectRect(position, new PVector(size.x + explosionRange, size.y + explosionRange), player.position, player.size)){
      isExploding = true;
    }
  }

  void takeDamage(float damageTaken){
    super.takeDamage(damageTaken);
  }
}
