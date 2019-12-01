public class GlassTile extends Tile{

  public GlassTile(int x, int y){
    super(x, y);

    image = ResourceManager.getImage("Glass");
    breakSound = ResourceManager.getSound("StoneBreak" + floor(random(1, 5))); // replace this!!
  }

}
