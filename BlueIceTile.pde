public class BlueIceTile extends ResourceTile
{
	public BlueIceTile(int x, int y)
	{
		super(x, y);

		particleColor = color(#0d7fdb);

		value = BLUE_ICE_VALUE;

		slipperiness = 1.1;

		image = ResourceManager.getImage("BlueIceBlock");
		pickupImage = ResourceManager.getImage("SaphirePickup");
	}
}
