public class TileBreakParticleSystem extends BaseParticleSystem
{
	public TileBreakParticleSystem(PVector spawnPos, int amount, float maxForce, color tileColor)
	{
		super(spawnPos, amount);

		for (int i = 0; i < particleAmount; i++)
		{
			float randomAngle = random(0, TWO_PI);
			float randomRadius = random(0, maxForce);
			float circleX = cos(randomAngle) * randomRadius;
			float circleY = sin(randomAngle) * randomRadius;
			PVector particleSpawnAcceleration = new PVector(circleX, circleY);

            PVector particleSpawnPosition = new PVector(position.x + random(TILE_SIZE), position.y + random(TILE_SIZE));

			TileBreakParticle particle = new TileBreakParticle(this, particleSpawnPosition, particleSpawnAcceleration, tileColor);
			load(particle);
		}
	}
}
