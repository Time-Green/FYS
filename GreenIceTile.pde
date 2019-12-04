public class GreenIceTile extends ResourceTile{

  public GreenIceTile(int x, int y){
    super(x, y);

    value = 500;
    slipperiness = 1.1;
    
    image = ResourceManager.getImage("GreenIceBlock");
    pickUpImage = ResourceManager.getImage("EmeraldPickup");
  }

}