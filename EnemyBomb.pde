class EnemyBomb extends Enemy {

  private float detectionRange = 80;
  
  private boolean isExploding = false;
  private float explosionTimer = 90f;
  private float explosionSize = 300;
  
  EnemyBomb(PVector spawnPos){
    super(spawnPos);

    image = ResourceManager.getImage("BombEnemy");
    this.speed = 2.5f;
  }

  void update() {
    super.update();

    tint(0, 153, 204, 126);
    if (isExploding) {

      this.speed = 0;
      //Decrease the explosion timer
      explosionTimer--;
      

      if (explosionTimer <= 0) {
        //Explode
        load(new Explosion(position, explosionSize, 15, true));
        delete(this);
      }
    }
  }

  protected void handleCollision(){
    super.handleCollision();

    //Activate the explosion sequence when the player gets to close
    if (CollisionHelper.rectRect(position, new PVector(size.x + detectionRange, size.y + detectionRange), player.position, player.size)){
      isExploding = true;
    }
  }

  void takeDamage(float damageTaken){
    super.takeDamage(damageTaken);
  }
}
