public class RedstoneTile extends ResourceTile {

  public RedstoneTile(int x, int y, int type) {
    super(x, y);

    value = Globals.REDSTONEVALUE;

    image = ResourceManager.getImage("RedstoneBlock");
    pickUpImage = ResourceManager.getImage("RedstonePickUp");
  }
}