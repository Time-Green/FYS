public class AmethystTile extends ResourceTile {

  public AmethystTile(int x, int y, int type) {
    super(x, y);

    value = Globals.AMETHYSTVALUE;

    image = ResourceManager.getImage("AmethystBlock");
    pickUpImage = ResourceManager.getImage("AmethystPickUp");
  }
}