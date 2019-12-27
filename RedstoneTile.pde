public class RedstoneTile extends ResourceTile {

  public RedstoneTile(int x, int y, int type) {
    super(x, y);

    value = REDSTONE_VALUE;

    image = ResourceManager.getImage("RedstoneBlock");
    pickupImage = ResourceManager.getImage("RedstonePickup");
  }
}