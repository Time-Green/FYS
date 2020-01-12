public class SnowTile extends SlowFallTile
{
	public SnowTile(int x, int y)
	{
		super(x, y);

		density = true; 

        slowdownCoeff = 0.97;

		image = ResourceManager.getImage("SnowBlock");
		particleImage = ResourceManager.getImage("SnowParticle");
        destroyedImage = ResourceManager.getImage("DestroyedIce");
	}
}
