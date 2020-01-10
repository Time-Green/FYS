public class MeteorTrailParticleSystem extends EmittingParticleSystem
{
	private PVector meteorSize = new PVector();
	float particleAmountCoefficient = 0.04;

	public MeteorTrailParticleSystem(PVector spawnPos, float maxForce, int spawnDelay, boolean onlyUpwardsParticles, PVector size)
	{
		super(spawnPos, maxForce, spawnDelay, onlyUpwardsParticles);

		meteorSize.set(size);
	}

    void spawnParticle()
    {
		int particleAmount = int(meteorSize.x * particleAmountCoefficient);

        for (int i = 0; i < particleAmount; i++)
		{
			float randomAngle = random(TWO_PI);
			float randomRadius = random(maxForce);
			float baseCircleX = cos(randomAngle);
			float baseCircleY = sin(randomAngle);
			float circleX = baseCircleX * randomRadius;
			float circleY = baseCircleY * randomRadius;
			
			if(onlyUpwardsParticles && circleY > 0)
			{
				circleY *= -1;
			}

			PVector particleSpawnAcceleration = new PVector(circleX, circleY);
			PVector particleSpawnPosition = new PVector(position.x + baseCircleX * (meteorSize.x / 3), position.y + baseCircleY * (meteorSize.y / 3));

			MeteorTrailParticle particle = new MeteorTrailParticle(this, particleSpawnPosition, particleSpawnAcceleration);
			load(particle);
		}
    }
}