public class AmethystTile extends ResourceTile {

  public AmethystTile(int x, int y, int type) {
    super(x, y);

    value = AMETHYST_VALUE;

    decalType = "DecalGolden";

    image = ResourceManager.getImage("AmethystBlock", true);
    pickupImage = ResourceManager.getImage("AmethystPickup");
  }
}