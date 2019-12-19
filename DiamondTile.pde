public class DiamondTile extends ResourceTile
{
	public DiamondTile(int x, int y, int type)
	{
		super(x, y);

		particleColor = color(#0997b0);

		value = Globals.DIAMONDVALUE;

		if(type == 0)
		{
			image = ResourceManager.getImage("DiamondBlock");
			decalType = "DecalStone";
		}
		else if(type == 1)
		{
			image = ResourceManager.getImage("ShadowDiamondBlock");
		}
		else
		{
			println("Type not found!");
		}

		pickUpImage = ResourceManager.getImage("DiamondPickUp");
	}
}
