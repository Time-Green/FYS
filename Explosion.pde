class Explosion extends BaseObject {

  //ArrayList<BaseObject> Explosion = new ArrayList<BaseObject>();

  float radius;
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
    this.radius = radius;

    //image = ResourceManager.getImage("Particle.jpg");
    //Sound = ResourceManager.getSound("Explosion.wav");
    explode();
  }

  void explode() {
    ArrayList<Tile> tilesInExplosionRadius = world.getTilesInRadius(position, radius);
    for (Tile tile : tilesInExplosionRadius) {
      if (!tile.density) 
        continue;

      tile.takeDamage(10);
    }

    CameraShaker.induceStress(1f);
  }

  void update() {
  }

  void draw() {
  }

  void fade() {
  }
}
