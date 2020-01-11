public class SingleParticle extends BaseParticle
{
	PImage image;

    public SingleParticle(BaseParticleSystem parentParticleSystem, PVector spawnLocation, PVector spawnAcc, PImage image)
    {
        super(parentParticleSystem, spawnLocation, spawnAcc);

		this.image = image;
    }

	void draw()
	{
		if (!inCameraView())
		{
			return;
		}

        tint(255, 255 - currentLifeTime / maxLifeTime * 255); 
		image(image, position.x, position.y, size, size);
        tint(255, 255);
	}

	void cleanup()
	{
		delete(this);
	}
}
