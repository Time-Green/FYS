public class GoldTile extends ResourceTile{

  public GoldTile(int x, int y){
    super(x, y);

    value = 500;
    
    image = ResourceManager.getImage("IronBlock");
    pickUpImage = ResourceManager.getImage("GoldPickUp");
  }
}
