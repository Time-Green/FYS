class Explosion extends BaseObject {

  float maxRadius; 
  float currentRadius = 0;
  float radiusIncrease = 35;

  float fade = 0.75f;
  float time = 180;
  //if the framerate is 60 then the time is 1 second, now the timer is set on 3 seconds
  boolean done = false;

  SoundFile explosionSound;

  Explosion(PVector spawnPos, float radius) {
    position = spawnPos.copy();
    maxRadius = radius;

    explosionSound = ResourceManager.getSound("Explosion");
  }

  void explode() {
    ArrayList<Tile> tilesInExplosionRadius = world.getTilesInRadius(position, currentRadius);
    for (Tile tile : tilesInExplosionRadius) {

      if (!tile.density) 
        continue;

      tile.takeDamage(10);
    }

    CameraShaker.induceStress(1f);
    explosionSound.play();
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
