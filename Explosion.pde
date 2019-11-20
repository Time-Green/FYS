class Explosion extends BaseObject{

  float maxRadius;
  float maxDamage = 5;
  float currentRadius = 0;
  float radiusIncrease = 35;

  float fade = 0.75f;
  float time = 180;

  SoundFile explosionSound;

  ArrayList<BaseObject> objectsInMaxRadius = new ArrayList<BaseObject>();

  Explosion(PVector spawnPos, float radius){
    position.set(spawnPos);
    maxRadius = radius;

    explosionSound = ResourceManager.getSound("Explosion");
    
    //flash
    setupLightSource(this, radius, 1f);

    //get objects inside max range
    objectsInMaxRadius = getObjectsInRadius(position, maxRadius);

    //create particle system
    ExplosionParticleSystem particleSystem = new ExplosionParticleSystem(position, 200, radius / 15);
    load(particleSystem);

    //play sound
    explosionSound.stop();
    explosionSound.play();
  }

  void explode(){
    ArrayList<BaseObject> objectsInCurrentExplosionRadius = new ArrayList<BaseObject>();

    for(BaseObject object : objectsInMaxRadius){

      if(dist(position.x, position.y, object.position.x, object.position.y) < currentRadius){
        objectsInCurrentExplosionRadius.add(object);
      }

    }

    for(BaseObject object : objectsInCurrentExplosionRadius){

      //damage falloff
      float dammage = maxDamage - ((currentRadius / maxRadius) * maxDamage);

      object.takeDamage(dammage);
    }

    CameraShaker.induceStress(0.05f);
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
