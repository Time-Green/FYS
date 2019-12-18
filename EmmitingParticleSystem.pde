// spawn particles over time
public class EmmitingParticleSystem extends BaseParticleSystem
{
    int spawnDelay;
    float maxForce;
    boolean onlyUpwardsParticles;

	public EmmitingParticleSystem(PVector spawnPos, float maxForce, int spawnDelay, boolean onlyUpwardsParticles)
	{
		super(spawnPos);

        this.spawnDelay = spawnDelay;
        this.maxForce = maxForce;
        this.onlyUpwardsParticles = onlyUpwardsParticles;
	}

    void update()
	{
		super.update();

        if(frameCount % spawnDelay == 0) 
        {
            spawnParticle();
        }
	}

    void spawnParticle()
    {
        float randomAngle = random(0, TWO_PI);
        float randomRadius = random(0, maxForce);
        float circleX = cos(randomAngle) * randomRadius;
        float circleY = sin(randomAngle) * randomRadius;

        if(onlyUpwardsParticles && circleY > 0)
        {
            circleY *= -1;
        }

        PVector particleSpawnAcceleration = new PVector(circleX, circleY);

        //println("particleSpawnAcceleration: " + particleSpawnAcceleration);

        ImageParticle particle = new ImageParticle(this, position, particleSpawnAcceleration);
        load(particle);
    }
}
