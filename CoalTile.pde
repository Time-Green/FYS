public class CoalTile extends ResourceTile {

  public CoalTile(int x, int y) {
    super(x, y);

    value = 50;

    image = ResourceManager.getImage("CoalBlock");
    pickUpImage = ResourceManager.getImage("CoalPickUp");
  }
}
