public class BlueIceTile extends ResourceTile
{
	public BlueIceTile(int x, int y)
	{
		super(x, y);

		particleColor = color(#0d7fdb);

		value = Globals.BLUEICEVALUE;

		slipperiness = 1.1;

		image = ResourceManager.getImage("BlueIceBlock");
		pickUpImage = ResourceManager.getImage("RubyPickup");
	}
}
