public class IceTile extends ResourceTile{

  public IceTile(int x, int y){
    super(x, y);

    value = 500;
    
    slipperiness = 1.1;
    
    image = ResourceManager.getImage("IceBlock");
    breakSound = ResourceManager.getSound("StoneBreak" + floor(random(1, 5)));
    pickUpImage = ResourceManager.getImage("GoldPickUp");
  }

}
