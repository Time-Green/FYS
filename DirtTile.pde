public class DirtTile extends Tile{

  public DirtTile(int x, int y){
    super(x, y);

    setMaxHp(2);

    image = ResourceManager.getImage("DirtBlock");
    breakSound = ResourceManager.getSound("DirtBreak"); 
  }
  
  void takeDamage(float damageTaken){
    super.takeDamage(damageTaken);
  }
}
