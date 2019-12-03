public class RedIceTile extends ResourceTile{

  public RedIceTile(int x, int y){
    super(x, y);

    value = 500;

    slipperiness = 1.1;
    
    image = ResourceManager.getImage("RedIceBlock");
    pickUpImage = ResourceManager.getImage("GoldPickUp");
  }

}