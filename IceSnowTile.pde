public class IceSnowTile extends Tile
{
	public IceSnowTile(int x, int y)
	{
		super(x, y);

		slipperiness = 1.1;

		particleColor = color(#37d4e6);

		healthMultiplier = 0.75f;

		image = ResourceManager.getImage("IceSnowTile", true);
		breakSound = "GlassBreak" + floor(random(1, 4));
		destroyedImage = ResourceManager.getImage("DestroyedIce");
	}
}
