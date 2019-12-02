public class IceTile extends Tile{

  public IceTile(int x, int y){
    super(x, y);
    
    slipperiness = 1.1;
    
    image = ResourceManager.getImage("IceBlock");
    breakSound = ResourceManager.getSound("StoneBreak" + floor(random(1, 5)));
  }

}
