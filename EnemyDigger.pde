class EnemyDigger extends Enemy {

  private float chaseDistance;
  private final float IDLESPEED = 0f;
  private float chaseSpeed = 3f;

  EnemyDigger(PVector spawnPos) {
    super(spawnPos);

    chaseSpeed = (chaseSpeed + (getDepth()/100));

    image = ResourceManager.getImage("DiggerEnemy");
    this.speed = IDLESPEED;
    //1f = 1 tile
    float tileDistance = 20f;
    chaseDistance = OBJECTSIZE * tileDistance;
  }

  void update() {
    super.update();

    float distanceToPlayer = dist(this.position.x, this.position.y, player.position.x, player.position.y);
    if (distanceToPlayer <= chaseDistance) {

      float playerX = player.position.x;
      float playerY = player.position.y;

      //Chase the player
      this.speed = chaseSpeed;

      if (this.position.x > playerX) this.walkLeft = true;//GO left
      else this.walkLeft = false;//Go right

      if (this.position.y < playerY) this.gravityForce = chaseSpeed/2;//Go down
      else this.gravityForce = -chaseSpeed;//Go up
      
      //Allowus to mine
      this.isMiningLeft = true;
      this.isMiningRight = true;
      this.isMiningDown = true;
      this.isMiningUp = true;

    } else {
      //Don't chase the player
      this.speed = IDLESPEED;
      this.isMiningLeft = false;
      this.isMiningRight = false;
      this.isMiningUp = false;
      this.isMiningDown = false;
      this.gravityForce = 0;
    }
  }
}
