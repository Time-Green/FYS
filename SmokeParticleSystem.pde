public class SmokeParticleSystem extends EmittingParticleSystem
{
	public SmokeParticleSystem(PVector spawnPos, float maxForce, int spawnDelay, boolean onlyUpwardsParticles)
	{
		super(spawnPos, maxForce, spawnDelay, onlyUpwardsParticles);
	}

    void spawnParticle()
    {
        PVector particleSpawnAcceleration = new PVector(0, maxForce);
        PVector spawnPos = new PVector(random(position.x, position.x + TILE_SIZE), random(position.y, position.y + TILE_SIZE)); //get a random location on the tile to draw from

        load(new SmokeParticle(this, spawnPos, particleSpawnAcceleration), PARTICLE_THREAD);
    }
}