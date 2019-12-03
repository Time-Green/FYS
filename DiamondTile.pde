public class DiamondTile extends ResourceTile{

  public DiamondTile(int x, int y){
    super(x, y);

    value = 1000;

    image = ResourceManager.getImage("DiamondBlock");
    pickUpImage = ResourceManager.getImage("DiamondPickUp");
  }

}
