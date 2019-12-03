public class ShadowTile extends Tile{

  public ShadowTile(int x, int y){
    super(x, y);
    
    
    image = ResourceManager.getImage("ShadowBlock");
    breakSound = ResourceManager.getSound("StoneBreak" + floor(random(1, 5)));
  }

}
