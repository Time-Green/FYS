public class IceTile2 extends ResourceTile {

  public IceTile2(int x, int y) {
    super(x, y);

    value = Globals.GREENICEVALUE;
    slipperiness = 1.1;

    image = ResourceManager.getImage("IceBlock2");
    pickUpImage = ResourceManager.getImage("SaphirePickup");
    breakSound = "GlassBreak" + floor(random(1, 4));
  }
}
