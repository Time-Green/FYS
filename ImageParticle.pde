public class ImageParticle extends BaseParticle
{
	float sizeDegrade;

	public ImageParticle(BaseParticleSystem parentParticleSystem, PVector spawnLocation, PVector spawnAcc)
	{
        super(parentParticleSystem, spawnLocation, spawnAcc);

		image = ResourceManager.getImage("Note" + floor(random(4)));

		sizeDegrade = random(0.5, 1);

        maxLifeTime = 5000;
        minSize = 15;
        maxSize = 20;
	}

	private void updateSize()
	{
		size -= sizeDegrade;

		if (size <= 0) {
			cleanup();
		}
	}

	void draw()
	{

	}
}
