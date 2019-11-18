class Explosion extends BaseObject{

  float maxRadius;
  float maxDamage = 5;
  float currentRadius = 0;
  float radiusIncrease = 35;

  float fade = 0.75f;
  float time = 180;

  SoundFile explosionSound;

  ArrayList<Tile> tilesInMaxExplosionRadius = new ArrayList<Tile>();

  Explosion(PVector spawnPos, float radius){
    position.set(spawnPos);
    maxRadius = radius;

    explosionSound = ResourceManager.getSound("Explosion");
    
    //flash
    setupLightSource(this, radius * 2f, 1f);

    //get tiles inside max range
    tilesInMaxExplosionRadius = world.getTilesInRadius(position, maxRadius);

    //create particle system
    ExplosionParticleSystem particleSystem = new ExplosionParticleSystem(position, 200, radius / 15);
    load(particleSystem);

    //play sound
    explosionSound.stop();
    explosionSound.play();
  }

  void explode(){
    ArrayList<Tile> tilesInCurrentExplosionRadius = new ArrayList<Tile>();

    for(Tile tile : tilesInMaxExplosionRadius){

      if(dist(position.x, position.y, tile.position.x, tile.position.y) < currentRadius){
        tilesInCurrentExplosionRadius.add(tile);
      }

    }

    for(Tile tile : tilesInCurrentExplosionRadius){

      //only deal damage to tiles that can be destroyed
      if(!tile.density) 
      {
        continue;
      }

      float dammage = maxDamage - ((currentRadius / maxRadius) * maxDamage);

      tile.takeDamage(dammage);
    }

    CameraShaker.induceStress(0.05f);

    //explosionSound.stop();
    //explosionSound.play();
  }

  void update(){
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

  void draw(){

  }

  void fade(){

  }
}
