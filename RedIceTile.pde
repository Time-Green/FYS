public class RedIceTile extends ResourceTile
{
	public RedIceTile(int x, int y)
	{
		super(x, y);

		particleColor = color(#c70c22);

		value = RED_ICE_VALUE;

		slipperiness = 1.1;

		image = ResourceManager.getImage("RedIceBlock");
		pickUpImage = ResourceManager.getImage("RubyPickUp");
	}
}
