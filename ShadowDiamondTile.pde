public class ShadowDiamondTile extends ResourceTile{

  public ShadowDiamondTile(int x, int y){
    super(x, y);

    value = 1000;
    
    image = ResourceManager.getImage("ShadowDiamondBlock");
    breakSound = ResourceManager.getSound("StoneBreak" + floor(random(1, 5)));
    pickUpImage = ResourceManager.getImage("DiamondPickUp");
  }

}