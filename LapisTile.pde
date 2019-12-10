public class LapisTile extends ResourceTile {

  public LapisTile(int x, int y) {
    super(x, y);

    image = ResourceManager.getImage("LapisBlock");
    breakSound = "GlassBreak" + floor(random(1, 4));
  
    pickUpImage = ResourceManager.getImage("DiamondPickUp");
  }
}
