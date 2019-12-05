public class IceTile2 extends ResourceTile {

  public IceTile2(int x, int y) {
    super(x, y);

    value = 300;
    slipperiness = 1.1;

    image = ResourceManager.getImage("IceBlock2");
    pickUpImage = ResourceManager.getImage("SaphirePickup");
    breakSound = "GlassBreak" + floor(random(1, 4));
  }
}
