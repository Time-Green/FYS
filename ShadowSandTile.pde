public class ShadowSandTile extends Tile
{
	public ShadowSandTile(int x, int y)
	{
		super(x, y);

		particleColor = color(#5e360d);

		healthMultiplier = 0.75f;
		slipperiness = 0.5;

		image = ResourceManager.getImage("ShadowSandBlock", true);
	}
}
