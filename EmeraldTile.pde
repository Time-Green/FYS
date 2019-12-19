public class EmeraldTile extends ResourceTile
{
	public EmeraldTile(int x, int y)
	{
		super(x, y);

		particleColor = color(#178f1c);

		value = 5000;

		image = ResourceManager.getImage("EmeraldTile");
		pickUpImage = ResourceManager.getImage("EmeraldPickup");
	}
}
