public class MeteorTrailParticleSystem extends BaseParticleSystem
{
	public MeteorTrailParticleSystem(PVector spawnPos, int amount, float maxForce, PVector size)
	{
		super(spawnPos, amount);
        
		for (int i = 0; i < particleAmount; i++)
		{
			float randomAngle = random(0, TWO_PI);
			float randomRadius = random(0, maxForce);
			float circleX = cos(randomAngle) * randomRadius;
			float circleY = sin(randomAngle) * randomRadius;
            
            if(circleY > 0)
            {
                circleY *= -1;
            }

            println("iets");

			PVector particleSpawnAcceleration = new PVector(circleX, circleY);

            PVector particleSpawnPosition = new PVector(position.x + size.x / 2, position.y + 60);

			MeteorTrailParticle particle = new MeteorTrailParticle(this, particleSpawnPosition, particleSpawnAcceleration);
			load(particle);
		}
	}
}
