public class ShadowSandTile extends Tile {

  public ShadowSandTile(int x, int y) {
    super(x, y);

    setMaxHp(2);
    slipperiness = 0.5;

    image = ResourceManager.getImage("ShadowSandBlock");
  }
}
