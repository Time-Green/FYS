public class LeafTile extends Tile{

  public LeafTile(int x, int y){
    super(x, y);

    image = ResourceManager.getImage("Leaf");
    breakSound = ResourceManager.getSound("StoneBreak" + floor(random(1, 5)));
      this.density = false; 
      destroyedImage = null;  
  }

  void takeDamage(float damageTaken){
    super.takeDamage(damageTaken);
  }
}
