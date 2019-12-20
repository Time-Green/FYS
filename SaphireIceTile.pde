public class SaphireIceTile extends ResourceTile
{
	public SaphireIceTile(int x, int y)
	{
		super(x, y);

		particleColor = color(#152fd6);

		value = GREEN_ICE_VALUE;
		slipperiness = 1.1;

		image = ResourceManager.getImage("IceBlock2");
		pickUpImage = ResourceManager.getImage("SaphirePickup");
		breakSound = "GlassBreak" + floor(random(1, 4));
	}
}
