public class ShadowTile extends Tile
{
	public ShadowTile(int x, int y)
	{
		super(x, y);

		particleColor = color(#18191c);

		image = ResourceManager.getImage("ShadowBlock", true);
	}
}
