public class DirtTile extends Tile
{
	public DirtTile(int x, int y)
	{
		super(x, y);

		healthMultiplier = 0.5f;

		particleColor = color(#6e3e26);

		canParallax = false;

		image = ResourceManager.getImage("DirtBlock", true);
		breakSound = "DirtBreak";
	}
}
