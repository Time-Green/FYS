class Explosion extends BaseObject{

  float maxRadius;
  float maxDamage = 100;
  float currentRadius = 0;
  float radiusIncrease = 35;

  boolean dealDamageToPlayer;

  SoundFile explosionSound;

  ArrayList<BaseObject> objectsInMaxRadius = new ArrayList<BaseObject>();

  Explosion(PVector spawnPos, float radius, float maxDamage, boolean dealDamageToPlayer){
    position.set(spawnPos);
    maxRadius = radius;
    this.maxDamage = maxDamage;
    this.dealDamageToPlayer = dealDamageToPlayer;

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

      if(!dealDamageToPlayer && object == player){
        continue;
      }

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
