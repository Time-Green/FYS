public class IceTile2 extends ResourceTile{

  public IceTile2(int x, int y){
    super(x, y);

    value = 500;
    
    image = ResourceManager.getImage("IceBlock2");
    breakSound = ResourceManager.getSound("StoneBreak" + floor(random(1, 5)));
    pickUpImage = ResourceManager.getImage("GoldPickUp");
  }

}