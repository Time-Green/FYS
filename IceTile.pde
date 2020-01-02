public class IceTile extends Tile
{
	public IceTile(int x, int y)
	{
		super(x, y);

		slipperiness = 1.1;

		particleColor = color(#37d4e6);

		healthMultiplier = 0.75f;

		image = ResourceManager.getImage("IceTile");
		breakSound = "GlassBreak" + floor(random(1, 4));
	}
}
