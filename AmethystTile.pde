public class AmethystTile extends ResourceTile {

  public AmethystTile(int x, int y, int type) {
    super(x, y);

    value = AMETHYST_VALUE;

    image = ResourceManager.getImage("AmethystBlock");
    pickUpImage = ResourceManager.getImage("AmethystPickUp");
  }
}