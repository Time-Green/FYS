public class StoneTile extends Tile
{
	public StoneTile(int x, int y)
	{
		super(x, y);

		decalType = "DecalStone";
		image = ResourceManager.getImage("StoneBlock", true);
	}
}
