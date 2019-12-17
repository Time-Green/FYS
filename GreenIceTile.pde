public class GreenIceTile extends ResourceTile
{
	public GreenIceTile(int x, int y)
	{
		super(x, y);
		
		particleColor = color(#24d12b);

		value = Globals.GREENICEVALUE;
		slipperiness = 1.1;

		image = ResourceManager.getImage("GreenIceBlock");
		pickUpImage = ResourceManager.getImage("EmeraldPickup");
	}
}
