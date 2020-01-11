public class ShineParticle extends BaseParticle
{
	PImage image = ResourceManager.getImage("Sparkle");

    public ShineParticle(BaseParticleSystem parentParticleSystem, PVector spawnLocation, PVector spawnAcc)
    {
        super(parentParticleSystem, spawnLocation, spawnAcc);
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
