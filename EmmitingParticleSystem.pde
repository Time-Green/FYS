// spawn particles over time
public class EmittingParticleSystem extends BaseParticleSystem
{
    int spawnDelay, currentFrameCounter;
    float maxForce;
    boolean onlyUpwardsParticles;

	public EmittingParticleSystem(PVector spawnPos, float maxForce, int spawnDelay, boolean onlyUpwardsParticles)
	{
		super(spawnPos);

        this.spawnDelay = spawnDelay;
        this.maxForce = maxForce;
        this.onlyUpwardsParticles = onlyUpwardsParticles;

        currentFrameCounter = floor(random(100));
	}

    void update()
	{
        if(gamePaused)
		{
			return;
		}

		super.update();

        if(spawnDelay == 0)
        {
            spawnParticle();
            
            return;
        }

        if(currentFrameCounter % spawnDelay == 0) 
        {
            spawnParticle();
        }

        currentFrameCounter++;
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

        ImageParticle particle = new ImageParticle(this, position, particleSpawnAcceleration);
        load(particle, PARTICLE_THREAD);
    }
}
