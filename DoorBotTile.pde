public class DoorBotTile extends Tile{

  public DoorBotTile(int x, int y){
    super(x, y);

    image = ResourceManager.getImage("DoorBot");
    breakSound = ResourceManager.getSound("StoneBreak" + floor(random(1, 5))); // replace this!!
  }

  void takeDamage(float damageTaken){
    super.takeDamage(damageTaken);
  }
}
