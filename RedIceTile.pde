public class RedIceTile extends ResourceTile
{
	public RedIceTile(int x, int y)
	{
		super(x, y);

		particleColor = color(#c70c22);

		value = Globals.REDICEVALUE;

		slipperiness = 1.1;

		image = ResourceManager.getImage("RedIceBlock");
		pickUpImage = ResourceManager.getImage("RubyPickup");
	}
}
