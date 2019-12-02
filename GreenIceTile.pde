public class GreenIceTile extends ResourceTile{

  public GreenIceTile(int x, int y){
    super(x, y);

    value = 500;
    slipperiness = 1.1;
    
    image = ResourceManager.getImage("GreenIceBlock");
    breakSound = ResourceManager.getSound("StoneBreak" + floor(random(1, 5)));
    pickUpImage = ResourceManager.getImage("GoldPickUp");
  }

}