public class LapisTile extends ResourceTile
{
	public LapisTile(int x, int y)
	{
		super(x, y);

		value = LAPIS_VALUE;

		image = ResourceManager.getImage("WaterStoneTile");
		breakSound = "GlassBreak" + floor(random(1, 4));
	
		pickupImage = ResourceManager.getImage("LapisPickup");
	}

	// void draw() {
	// 	super.draw();

	// 	tint(0, 216, 255);
	// }
}
