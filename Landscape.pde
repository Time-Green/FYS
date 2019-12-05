public class LeafTile extends Tile {

  public LeafTile(int x, int y) {
    super(x, y);

    image = ResourceManager.getImage("Leaf");
  }
}

public class WoodTile extends Tile {

  public WoodTile(int x, int y) {
    super(x, y);

    image = ResourceManager.getImage("Wood");
    this.density = false; 
    destroyedImage = null;
  }
}

public class WoodBirchTile extends Tile {

  public WoodBirchTile(int x, int y) {
    super(x, y);

    image = ResourceManager.getImage("WoodBirch");
    this.density = false; 
    destroyedImage = null;
  }
}
