public class LapisTile extends ResourceTile
{
	public LapisTile(int x, int y)
	{
		super(x, y);

		value = LAPIS_VALUE;

		image = ResourceManager.getImage("LapisBlock");
		breakSound = "GlassBreak" + floor(random(1, 4));
	
		pickupImage = ResourceManager.getImage("LapisPickup");
	}
}
