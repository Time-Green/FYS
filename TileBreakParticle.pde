public class TileBreakParticle extends BaseParticle
{
	float sizeDegrade;

	public TileBreakParticle(BaseParticleSystem parentParticleSystem, PVector spawnLocation, PVector spawnAcc, color tileColor)
	{
		super(parentParticleSystem, spawnLocation, spawnAcc);

	    minSize = 10;
	    maxSize = 12;
        size = random(minSize, maxSize);

		particleColor = tileColor;
		sizeDegrade = random(0.3, 0.5);
	}

	void update()
	{
		if (gamePaused)
		{
			return;
		}
		
		super.update();

		updateSize();
	}

	private void updateSize()
	{
		size -= sizeDegrade * TimeManager.deltaFix;

		if (size <= 0)
		{
			cleanup();
		}
	}
}
