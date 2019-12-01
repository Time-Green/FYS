public class DoorTopTile extends Tile{

  public DoorTopTile(int x, int y){
    super(x, y);

    image = ResourceManager.getImage("DoorTop");
    breakSound = ResourceManager.getSound("StoneBreak" + floor(random(1, 5))); // replace this!!
  }

}
