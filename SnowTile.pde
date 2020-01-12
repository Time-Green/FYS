public class SnowTile extends SlowFallTile
{
	public SnowTile(int x, int y)
	{
		super(x, y);

		density = true; 

		image = ResourceManager.getImage("SnowBlock");
		particleImage = ResourceManager.getImage("SnowParticle");
        destroyedImage = ResourceManager.getImage("DestroyedIce");
	}
}
