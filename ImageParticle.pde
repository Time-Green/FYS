public class ImageParticle extends BaseParticle
{
	public ImageParticle(BaseParticleSystem parentParticleSystem, PVector spawnLocation, PVector spawnAcc)
	{
        super(parentParticleSystem, spawnLocation, spawnAcc);

		image = ResourceManager.getImage("Note" + floor(random(4)));
		gravityForce = 0;
        maxLifeTime = 2000;
		minSize = 15;
        maxSize = 20;

		size = random(minSize, maxSize);
        //maxLifeTime = 1000;
	}

	void draw()
	{
		image(image, position.x, position.y, size, size);
	}
}
