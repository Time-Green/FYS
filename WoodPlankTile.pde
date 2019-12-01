public class WoodPlankTile extends Tile{

  public WoodPlankTile(int x, int y){
    super(x, y);

    image = ResourceManager.getImage("WoodPlank");
    breakSound = ResourceManager.getSound("StoneBreak" + floor(random(1, 5))); // replace this!!
  }

}
