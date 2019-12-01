class EnemyBomb extends Enemy {

  AnimatedImage explosionSequence;
  final int NUMBEROFSPRITES = 9;
  private float detectionRange = 80;
  
  private boolean isExploding = false;
  private float explosionTimer = 90f;
  private float explosionSize = 300;
  
  EnemyBomb(PVector spawnPos){
    super(spawnPos);

    image = ResourceManager.getImage("BombEnemy0");
    this.speed = 2.5f;

    PImage[] frames = new PImage[NUMBEROFSPRITES];

    for(int i = 0; i < NUMBEROFSPRITES; i++) {
      frames[i] = ResourceManager.getImage("BombEnemy" + i);
    }

    explosionSequence = new AnimatedImage(frames, explosionTimer / NUMBEROFSPRITES, position, size.x, !walkLeft);
    
  }

  void update() {
    super.update();

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

  void draw() {
    //Normal animation
    if (!isExploding) super.draw();
    //Explode animation
    else explosionSequence.draw();
  }

  protected void handleCollision(){
    super.handleCollision();

    //Activate the explosion sequence when the player gets to close
    if (CollisionHelper.rectRect(position, new PVector(size.x + detectionRange, size.y + detectionRange), player.position, player.size) && isExploding == false){
      isExploding = true;
      explosionSequence.flipSpriteHorizontal = flipSpriteHorizontal;
    }
  }

}
