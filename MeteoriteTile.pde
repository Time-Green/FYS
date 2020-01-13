public class MeteoriteTile extends ResourceTile
{
	public MeteoriteTile(int x, int y)
	{
		super(x, y);

		particleColor = color(#178f1c);

		value = 5000;

		decalType = "DecalVulcanic";

		image = ResourceManager.getImage("MeteoriteTile", true);
		pickupImage = ResourceManager.getImage("MeteoritePickup");
	}
}
