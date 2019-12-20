public class IronTile extends ResourceTile
{
	public IronTile(int x, int y)
	{
		super(x, y);

		value = IRON_VALUE;
		
		particleColor = color(#ccccc6);

		image = ResourceManager.getImage("IronBlock");
		pickUpImage = ResourceManager.getImage("IronPickUp");
		decalType = "DecalStone";
	}
}
