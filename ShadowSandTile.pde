public class ShadowSandTile extends Tile {

  public ShadowSandTile(int x, int y) {
    super(x, y);

    healthMultiplier = 0.75f;
    //setMaxHp(2);
    slipperiness = 0.5;

    image = ResourceManager.getImage("ShadowSandBlock");
  }
}
