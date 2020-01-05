public class GrassTile extends Tile
{
	public GrassTile(int x, int y)
	{
		super(x, y);

		particleColor = color(#33540d);

		canParallax = false;

		image = ResourceManager.getImage("GrassBlock");
		breakSound = "DirtBreak";

		// simulates sun
		setupLightSource(this, 600f, 0.03f);
	}
}
