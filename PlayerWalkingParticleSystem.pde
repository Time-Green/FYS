public class PlayerWalkingParticleSystem extends BaseParticleSystem
{
	public PlayerWalkingParticleSystem(PVector spawnPos, int amount, float maxForce, color tileColor)
	{
		super(spawnPos, amount);
        
		for (int i = 0; i < particleAmount; i++)
		{
			float randomAngle = random(0, TWO_PI);
			float randomRadius = random(0, maxForce);
			float circleX = cos(randomAngle) * randomRadius;
			float circleY = sin(randomAngle) * randomRadius;
			PVector particleSpawnAcceleration = new PVector(circleX, circleY);

            if(circleY > 0)
            {
                circleY *= -1;
            }

            PVector particleSpawnPosition = new PVector(position.x + 20, position.y + 35);

			PlayerWalkingParticle particle = new PlayerWalkingParticle(this, particleSpawnPosition, particleSpawnAcceleration, tileColor);
			load(particle);
		}
	}
}
