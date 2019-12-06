public class GoldTile extends ResourceTile {

  public GoldTile(int x, int y) {
    super(x, y);

    value = Globals.GOLDVALUE;

    image = ResourceManager.getImage("IronBlock");
    pickUpImage = ResourceManager.getImage("GoldPickUp");
  }
}
