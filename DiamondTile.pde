public class DiamondTile extends ResourceTile{

  public DiamondTile(int x, int y){
    super(x, y);

    value = 1000;

    image = ResourceManager.getImage("DiamondBlock");
    breakSound = ResourceManager.getSound("StoneBreak" + floor(random(1, 5)));
    pickUpImage = ResourceManager.getImage("DiamondPickUp");
  }

}
