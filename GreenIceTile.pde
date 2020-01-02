public class GreenIceTile extends ResourceTile
{
	public GreenIceTile(int x, int y)
	{
		super(x, y);
		
		particleColor = color(#24d12b);

		value = GREEN_ICE_VALUE;
		slipperiness = 1.1;

		image = ResourceManager.getImage("GreenIceBlock");
		pickupImage = ResourceManager.getImage("EmeraldPickup");
	}
}
