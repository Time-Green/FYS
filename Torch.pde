public class Torch extends Movable{

  private float startingBrightness = 200;
  private float minBrightness = 150;
  private float maxBrightness = 250;

  public Torch(PVector spawnPos){
    super();

    position.set(spawnPos);
    image = ResourceManager.getImage("Torch");
      
    collisionEnabled = false;
    gravityForce = 0;

    setupLightSource(this, startingBrightness, 1f);
  }

  public void update(){
    super.update();

    //light flikker
    lightEmitAmount += random(-5f, 5f);
    lightEmitAmount = constrain(lightEmitAmount, minBrightness, maxBrightness);
  }

  void takeDamage(float damageTaken){
    super.takeDamage(damageTaken);

    delete(this);
  }
}
