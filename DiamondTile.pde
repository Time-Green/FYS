public class DiamondTile extends ResourceTile
{
	public DiamondTile(int x, int y, int type)
	{
		super(x, y);

		particleColor = color(#0997b0);

		value = DIAMOND_VALUE;

		if(type == 0)
		{
			image = ResourceManager.getImage("DiamondBlock", true);
			decalType = "DecalGolden";
		}
		else if(type == 1)
		{
			image = ResourceManager.getImage("ShadowDiamondBlock", true);
		}
		else
		{
			println("Type not found!");
		}

		pickupImage = ResourceManager.getImage("DiamondPickup");
	}
}
