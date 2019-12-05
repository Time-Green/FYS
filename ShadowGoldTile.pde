public class ShadowGoldTile extends ResourceTile {

  public ShadowGoldTile(int x, int y) {
    super(x, y);

    value = 500;

    image = ResourceManager.getImage("ShadowGoldBlock");
    pickUpImage = ResourceManager.getImage("GoldPickUp");
  }
}
