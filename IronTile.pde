public class IronTile extends ResourceTile
{
	public IronTile(int x, int y)
	{
		super(x, y);

		value = Globals.IRONVALUE;
		
		particleColor = color(#ccccc6);

		image = ResourceManager.getImage("IronBlock");
		pickUpImage = ResourceManager.getImage("IronPickUp");
	}
}
