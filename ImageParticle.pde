// public class ImageParticle extends BaseParticle
// {
// 	float sizeDegrade;

    

// 	public ImageParticle(BaseParticleSystem parentParticleSystem, PVector spawnLocation, PVector spawnAcc)
// 	{

// 		image = ResourceManager.getImage("Jukebox");

// 		super(parentParticleSystem, spawnLocation, spawnAcc);
// 		sizeDegrade = random(0.5, 1);

//         maxLifeTime = 5000;
//         minSize = 15;
//         maxSize = 20;
// 	}

// 	void update()
// 	{

// 		updateSize();
// 	}

// 	void draw()
// 	{
// 		image(img, position.x, position.y);
// 	}

// 	private void updateSize()
// 	{
// 		size -= sizeDegrade;

// 		if (size <= 0) {
// 			cleanup();
// 		}
// 	}
// }
