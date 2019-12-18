public class EmmitingParticleSystem extends BaseParticleSystem
{
    int spawnDelay;
    float maxForce;

	public EmmitingParticleSystem(PVector spawnPos, float maxForce, int spawnDelay)
	{
		super(spawnPos);

        this.spawnDelay = spawnDelay;
        this.maxForce = maxForce;
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
        PVector particleSpawnAcceleration = new PVector(circleX, circleY);

        ImageParticle particle = new ImageParticle(this, position, particleSpawnAcceleration);
        load(particle);
    }
}
