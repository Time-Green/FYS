class Explosion extends BaseObject {

  float maxRadius;
  float maxDamage = 5;
  float currentRadius = 0;
  float radiusIncrease = 35;

  float fade = 0.75f;
  float time = 180;

  SoundFile explosionSound;

  Explosion(PVector spawnPos, float radius) {
    position.set(spawnPos);
    maxRadius = radius;

    explosionSound = ResourceManager.getSound("Explosion");
    
    //flash
    setupLightSource(this, radius * 2f, 1f);

    ExplosionParticleSystem particleSystem = new ExplosionParticleSystem(position, 500, radius / 10);
    load(particleSystem);
  }

  void explode() {
    ArrayList<Tile> tilesInExplosionRadius = world.getTilesInRadius(position, currentRadius);

    for (Tile tile : tilesInExplosionRadius) {

      if (!tile.density) 
        continue;

      float dammage = maxDamage - ((currentRadius / maxRadius) * maxDamage);

      tile.takeDamage(dammage);
    }

    CameraShaker.induceStress(0.05f);

    explosionSound.stop();
    explosionSound.play();
  }

  void update() {
    super.update();

    if(currentRadius < maxRadius) {
      currentRadius += radiusIncrease;

      if(currentRadius > maxRadius){
        currentRadius = maxRadius;
      }

      explode();
    }
    else{
      delete(this);
    }
  }

  void draw() {
  }

  void fade() {
  }
}
