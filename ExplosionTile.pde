public class ExplosionTile extends Tile{

  private float explosionSize = 250;

  public ExplosionTile(int x, int y){
    super(x, y); 
    image = ResourceManager.getImage("TNTBlock");
    breakSound = ResourceManager.getSound("StoneBreak" + floor(random(1, 5)));
  }

  void mine(){
    super.mine();
    load(new Explosion(position, explosionSize));
  }

  void takeDamage(float damageTaken){
    super.takeDamage(damageTaken);
  }
}