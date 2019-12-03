class EnemyDigger extends Enemy {

  private float chaseDistance;
  private boolean chasePlayer;
  private final float CHASESPEED = 4f;
  private final float NORMALSPEED = 2f;

  EnemyDigger(PVector spawnPos){
    super(spawnPos);

    image = ResourceManager.getImage("DiggerEnemy");
    this.speed = NORMALSPEED;
    //1f = 1 tile
    float tileDistance = 10f;
    chaseDistance = OBJECTSIZE * tileDistance;
  }

  void update() {
    super.update();

    float distanceToPlayer = dist(this.position.x, this.position.y, player.position.x, player.position.y);
    if (distanceToPlayer <= chaseDistance) {

      //Chase the player
      this.speed = CHASESPEED;

      if (player.position.x < this.position.x) this.walkLeft = true;
      else this.walkLeft = false;

      if (this.walkLeft) {//GO left
          this.isMiningLeft = true;
          this.isMiningRight = false;
      } else {//Go right
          this.isMiningLeft = false;
          this.isMiningRight = true;
      }

      if (player.position.y > this.position.y) {//Go down
          this.isMiningDown = true;
          this.isMiningUp = false;
          this.gravityForce = 1;
      } else {//Go up
          this.isMiningUp = true;
          this.isMiningDown = false;
          this.gravityForce = -1;
      }

    } else {
      //Don't chase the player
      this.speed = NORMALSPEED;
      this.isMiningDown = false;
      this.gravityForce = 1;
    }
  }

}
