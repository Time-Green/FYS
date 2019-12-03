public class ShadowGoldTile extends ResourceTile{

  public ShadowGoldTile(int x, int y){
    super(x, y);

    value = 500;
    
    image = ResourceManager.getImage("ShadowGoldBlock");
    breakSound = ResourceManager.getSound("StoneBreak" + floor(random(1, 5)));
    pickUpImage = ResourceManager.getImage("GoldPickUp");
  }

}