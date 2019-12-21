public class MeteoriteTile extends ResourceTile
{
	public MeteoriteTile(int x, int y)
	{
		super(x, y);

		particleColor = color(#178f1c);

		value = 5000;

		image = ResourceManager.getImage("MeteoriteTile");
		pickUpImage = ResourceManager.getImage("MeteoritePickup");
	}
}
