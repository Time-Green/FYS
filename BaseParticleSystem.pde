public class BaseParticleSystem extends BaseObject {

  protected int particleAmount;
  protected int currentParticleAmount;

  public BaseParticleSystem(PVector spawnPos, int amount)
  {
    super();

    position.set(spawnPos);
    particleAmount = amount;
    currentParticleAmount = amount;
  }

  void update(){
    super.update();

    if(currentParticleAmount <= 0){
      delete(this);
    }
  }

  void draw(){
    super.draw();
  }
}
