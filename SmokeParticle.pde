public class SmokeParticle extends BaseParticle
{
	float sizeDegrade;

	final color YELLOWCOLOR = color(#7C0A02);
	final color BLACKCOLOR = color(0);

	public SmokeParticle(BaseParticleSystem parentParticleSystem, PVector spawnLocation, PVector spawnAcc)
	{
		super(parentParticleSystem, spawnLocation, spawnAcc);

		particleColor = lerpColor(YELLOWCOLOR, BLACKCOLOR, random(1));
		sizeDegrade = random(0.1, 0.5); //every tick the size goes minus this, so bigger is faster and smaller is slower
	}

	void update()
	{
		if(gamePaused)
		{
			return;
		}
		
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
