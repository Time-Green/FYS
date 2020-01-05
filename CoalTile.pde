public class CoalTile extends ResourceTile
{
	public CoalTile(int x, int y)
	{
		super(x, y);

		value = COAL_VALUE;

		particleColor = color(#262625);

		image = ResourceManager.getImage("CoalBlock", true);
		pickupImage = ResourceManager.getImage("CoalPickup");
		decalType = "DecalStone";
	}
}
