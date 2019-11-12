class Explosion extends BaseObject {

  //ArrayList<BaseObject> Explosion = new ArrayList<BaseObject>();

  float maxRadius; 
  float currentRadius = 0;
  float radiusIncrease = 35;
  
  //player.position.x
  //player.position.y
  //player.takeDamage
  //tile.takeDamage

  float fade = 0.75f;
  float time = 180;
  //if the framerate is 60 then the time is 1 second, now the timer is set on 3 seconds
  boolean done = false;


  Explosion(PVector spawnPos, float radius) {
    position = spawnPos.copy();
    maxRadius = radius;

    //image = ResourceManager.getImage("Particle.jpg");
    //Sound = ResourceManager.getSound("Explosion.wav");

  }

  void explode() {
    ArrayList<Tile> tilesInExplosionRadius = world.getTilesInRadius(position, currentRadius);
    for (Tile tile : tilesInExplosionRadius) {

      if (!tile.density) 
        continue;

      tile.takeDamage(10);
    }

    CameraShaker.induceStress(1f);
  }

  void update() {
    super.update();

    if(currentRadius <= maxRadius) {
      currentRadius += radiusIncrease;
      explode();
    }
  }

  void draw() {
  }

  void fade() {
  }
}
