public class ExplosionTile extends Tile{

  private float explosionSize = 250;
  private boolean hasExploded = false;

  public ExplosionTile(int x, int y){
    super(x, y); 

    image = ResourceManager.getImage("TNTBlock");
    breakSound = ResourceManager.getSound("StoneBreak" + floor(random(1, 5)));
  }

  void mine(boolean playMineSound){
    super.mine(playMineSound);
    
    explode();
  }

  private void explode(){

    if(hasExploded){
      return;
    }

    hasExploded = true;
    
    load(new Explosion(position, explosionSize, 5, false)); // do player damage??
  }

}