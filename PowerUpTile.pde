public class PowerUpTile extends Tile
{
	public PowerUpTile(int x, int y)
	{
		super(x, y); 
		
		image = ResourceManager.getImage("MysteryBlock");
	}

	void mine()
	{
		super.mine(true);
	}
}
