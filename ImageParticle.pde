public class ImageParticle extends BaseParticle
{
	float sizeDegrade;
    

	public ImageParticle(BaseParticleSystem parentParticleSystem, PVector spawnLocation, PVector spawnAcc)
	{
		super(parentParticleSystem, spawnLocation, spawnAcc);
		sizeDegrade = random(0.5, 1);

        maxLifeTime = 5000;
        minSize = 15;
        maxSize = 20;
	}

	void update()
	{
		super.update();

		updateSize();
	}

	private void updateSize()
	{
		size -= sizeDegrade;

		if (size <= 0) {
			cleanup();
		}
	}
}
