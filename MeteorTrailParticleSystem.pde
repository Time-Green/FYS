public class MeteorTrailParticleSystem extends EmittingParticleSystem
{
	private final int PARTICLES_PER_SPAWN = 5;

	public MeteorTrailParticleSystem(PVector spawnPos, float maxForce, int spawnDelay, boolean onlyUpwardsParticles)
	{
		super(spawnPos, maxForce, spawnDelay, onlyUpwardsParticles);
	}

    void spawnParticle()
    {
        for (int i = 0; i < PARTICLES_PER_SPAWN; i++)
		{
			float randomAngle = random(TWO_PI);
			float randomRadius = random(maxForce);
			float circleX = cos(randomAngle) * randomRadius;
			float circleY = sin(randomAngle) * randomRadius;
			
			if(onlyUpwardsParticles && circleY > 0)
			{
				circleY *= -1;
			}

			PVector particleSpawnAcceleration = new PVector(circleX, circleY);
			PVector particleSpawnPosition = new PVector(position.x + circleX * 7.5f, position.y + circleY * 7.5f);

			MeteorTrailParticle particle = new MeteorTrailParticle(this, particleSpawnPosition, particleSpawnAcceleration);
			load(particle);
		}
    }
}