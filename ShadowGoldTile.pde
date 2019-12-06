public class ShadowGoldTile extends ResourceTile {

  public ShadowGoldTile(int x, int y) {
    super(x, y);

    value = Globals.GOLDVALUE;

    image = ResourceManager.getImage("ShadowGoldBlock");
    pickUpImage = ResourceManager.getImage("GoldPickUp");
  }
}
