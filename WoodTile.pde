public class WoodTile extends Tile{

  public WoodTile(int x, int y){
    super(x, y);

    image = ResourceManager.getImage("Wood");
    breakSound = ResourceManager.getSound("StoneBreak" + floor(random(1, 5)));
      this.density = false; 
      destroyedImage = null;  
  }

  void takeDamage(float damageTaken){
    super.takeDamage(damageTaken);
  }
}
