public class DoorBotTile extends Tile {

  public DoorBotTile(int x, int y) {
    super(x, y);

    image = ResourceManager.getImage("DoorBot");
  }
}

public class DoorTopTile extends Tile {

  public DoorTopTile(int x, int y) {
    super(x, y);

    image = ResourceManager.getImage("DoorTop");
  }
}

public class GlassTile extends Tile {

  public GlassTile(int x, int y) {
    super(x, y);

    image = ResourceManager.getImage("Glass");
  }
}

public class WoodPlankTile extends Tile {

  public WoodPlankTile(int x, int y) {
    super(x, y);

    image = ResourceManager.getImage("WoodPlank");
  }
}
