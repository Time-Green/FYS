public class PlayerWalkingParticle extends BaseParticle
{
	float sizeDegrade;

	final color WHITE = color(255);

	public PlayerWalkingParticle(BaseParticleSystem parentParticleSystem, PVector spawnLocation, PVector spawnAcc, color tileColor)
	{
		super(parentParticleSystem, spawnLocation, spawnAcc);

        minSize = 3;
	    maxSize = 6;
        size = random(minSize, maxSize);

		particleColor = tileColor;

        sizeDegrade = random(0.3, 0.5);
	}

	void update()
	{
		super.update();

		updateSize();
	}

	private void updateSize()
	{
		size -= sizeDegrade;

		if (size <= 0)
		{
			cleanup();
		}
	}
}
