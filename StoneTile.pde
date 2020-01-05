public class StoneTile extends Tile
{
	public StoneTile(int x, int y)
	{
		super(x, y);

		decalType = "DecalStone";
		parallaxDecalType = "DecalStoneParallax";
		image = ResourceManager.getImage("StoneBlock", true);
	}
}