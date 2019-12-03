public class ShadowDiamondTile extends ResourceTile{

  public ShadowDiamondTile(int x, int y){
    super(x, y);

    value = 1000;
    
    image = ResourceManager.getImage("ShadowDiamondBlock");
    pickUpImage = ResourceManager.getImage("DiamondPickUp");
  }

}