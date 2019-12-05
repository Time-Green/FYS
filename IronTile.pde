public class IronTile extends ResourceTile {

  public IronTile(int x, int y) {
    super(x, y);

    value = 100;

    image = ResourceManager.getImage("IronBlock");
    pickUpImage = ResourceManager.getImage("IronPickUp");
  }
}
