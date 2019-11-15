public class StoneTile extends Tile{

    public StoneTile(int x, int y){
      super(x, y);

      image = ResourceManager.getImage("StoneBlock");
      breakSound = ResourceManager.getSound("StoneBreak" + floor(random(1, 5)));
    }

}
