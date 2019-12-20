public class GoldTile extends ResourceTile
{
	public GoldTile(int x, int y, int type)
	{
		super(x, y);

		particleColor = color(#bdaf13);

		value = GOLD_VALUE;

		if(type == 0)
		{
			image = ResourceManager.getImage("IronBlock"); // ironblock for gold???
			decalType = "DecalStone";
		}
		else if(type == 1)
		{
			image = ResourceManager.getImage("ShadowGoldBlock");
		}
		else
		{
			println("Type not found!");
		}

		pickUpImage = ResourceManager.getImage("GoldPickUp");
	}
}
