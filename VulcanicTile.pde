class VulcanicTile extends Tile
{
	VulcanicTile(int x, int y)
	{
		super(x, y);
		
		particleColor = color(#8c071d);

		decalType = "DecalVulcanic";

		image = ResourceManager.getImage("VulcanicTile", true);
	}
}
