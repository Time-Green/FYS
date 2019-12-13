public class WaterTile extends Tile {

  public WaterTile(int x, int y) {
    super(x, y);

    //Act as water
    density = false;
    // loadInBack = false;

    image = ResourceManager.getImage("WaterBlock");
  }
}
