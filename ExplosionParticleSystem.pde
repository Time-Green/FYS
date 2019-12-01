public class ExplosionParticleSystem extends BaseParticleSystem {

  public ExplosionParticleSystem(PVector spawnPos, int amount, float maxForce){
    super(spawnPos, amount);

    for(int i = 0; i < particleAmount; i++)
    {
        float randomAngle = random(0, TWO_PI);
        float randomRadius = random(0, maxForce);
        float circleX = cos(randomAngle) * randomRadius;
        float circleY = sin(randomAngle) * randomRadius;
        PVector particleSpawnAcceleration = new PVector(circleX, circleY);

        ExplosionParticle particle = new ExplosionParticle(this, position, particleSpawnAcceleration);
        load(particle);
    }
  }

}
