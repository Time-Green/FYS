public class MeteorTrailParticle extends BaseParticle
{
	float sizeDegrade;

    final color BLACKCOLOR = color(#1a0406);
    final color REDCOLOR = color(#6b0e16);
    final color YELLOWCOLOR = color(#F6F052);

	public MeteorTrailParticle(BaseParticleSystem parentParticleSystem, PVector spawnLocation, PVector spawnAcc)
	{
		super(parentParticleSystem, spawnLocation, spawnAcc);

        particleColor = lerpColor(YELLOWCOLOR, REDCOLOR, random(1));

        minSize = 10;
	    maxSize = 15;
        size = random(minSize, maxSize);

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
