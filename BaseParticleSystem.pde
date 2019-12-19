public class BaseParticleSystem extends BaseObject
{
	protected int particleAmount;
	protected int currentParticleAmount;

	private boolean deleteOnZeroParticles = true;

	public BaseParticleSystem(PVector spawnPos, int amount)
	{
		super();

		position.set(spawnPos);
		particleAmount = amount;
		currentParticleAmount = amount;
	}

	public BaseParticleSystem(PVector spawnPos)
	{
		super();

		position.set(spawnPos);
		deleteOnZeroParticles = false;
	}

	void update()
	{
		super.update();

		if (deleteOnZeroParticles && currentParticleAmount <= 0)
		{
			delete(this);
		}
	}

	void takeDamage(float damageTaken)
	{
		
	}
}
