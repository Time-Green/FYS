public class DoorBotTile extends Tile
{
	public DoorBotTile(int x, int y)
	{
		super(x, y);

		image = ResourceManager.getImage("DoorBot");
	}
}

public class DoorTopTile extends Tile
{
	public DoorTopTile(int x, int y)
	{
		super(x, y);

		image = ResourceManager.getImage("DoorTop");
	}
}

public class GlassTile extends Tile
{
	public GlassTile(int x, int y)
	{
		super(x, y);

		image = ResourceManager.getImage("Glass");
	}
}

public class WoodPlankTile extends Tile
{
	// normal wood plank
	public WoodPlankTile(int x, int y)
	{
		super(x, y);

		drawLayer = BACKWALL_LAYER;
		image = ResourceManager.getImage("WoodPlank");
	}

	// leaderboard wood plank
	public WoodPlankTile(int x, int y, PVector structureTilePosition)
	{
		super(x, y);
		
		drawLayer = BACKWALL_LAYER;

		setLeaderboardImage(structureTilePosition);
	}

	private void setLeaderboardImage(PVector structureTilePosition)
	{
		PGraphics pg = createGraphics(50, 50);

		int xPos = int(structureTilePosition.x * Globals.TILE_SIZE);
		int yPos = int(structureTilePosition.y * Globals.TILE_SIZE);
		int size = int(Globals.TILE_SIZE);

		PImage cutImage = leaderBoardGraphics.get(xPos, yPos, size, size);

		pg.beginDraw();
		pg.image(ResourceManager.getImage("WoodPlank"), 0, 0, Globals.TILE_SIZE, Globals.TILE_SIZE);
		pg.image(cutImage, 0, 0, size, size);
		pg.endDraw();

		image = pg;
	}
}

public class Fencepost extends Tile
{
	public Fencepost(int x, int y)
	{
		super(x, y);

		drawLayer = BACKWALL_LAYER;
		image = ResourceManager.getImage("Fencepost");
	}
}