public class LapisTile extends ResourceTile {

  public LapisTile(int x, int y) {
    super(x, y);

    value = Globals.LAPISVALUE;

    image = ResourceManager.getImage("LapisBlock");
  
    pickUpImage = ResourceManager.getImage("LapisPickup");
  }
}
