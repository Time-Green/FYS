public class DirtStoneTransitionTile extends Tile
{
	public DirtStoneTransitionTile(int x, int y)
	{
		super(x, y);

		image = ResourceManager.getImage("MossBlock");
		breakSound = "DirtBreak";
	}
}
