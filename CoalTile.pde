public class CoalTile extends ResourceTile
{
	public CoalTile(int x, int y)
	{
		super(x, y);

		value = COAL_VALUE;

		particleColor = color(#262625);

		//image = ResourceManager.getRandomFlippedImage("CoalBlock"); WIP
		image = ResourceManager.getImage("CoalBlock");
		pickUpImage = ResourceManager.getImage("CoalPickUp");
		decalType = "DecalStone";
	}
}
