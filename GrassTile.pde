public class GrassTile extends Tile {

  public GrassTile(int x, int y) {
    super(x, y);

    image = ResourceManager.getImage("GrassBlock");
    breakSound = "DirtBreak";

    setupLightSource(this, 600f, 0.03f);
  }
}
