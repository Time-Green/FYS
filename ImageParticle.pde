public class ImageParticle extends BaseParticle
{
	public ImageParticle(BaseParticleSystem parentParticleSystem, PVector spawnLocation, PVector spawnAcc)
	{
        super(parentParticleSystem, spawnLocation, spawnAcc);

		image = ResourceManager.getImage("Note" + floor(random(4)));
		gravityForce = 0;
        maxLifeTime = 5000;
		minSize = 15;
        maxSize = 20;

		size = random(minSize, maxSize);
	}

	void draw()
	{
		image(image, position.x, position.y, size, size);
	}
}
