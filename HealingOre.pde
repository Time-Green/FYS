public class HealthTile extends Tile{

  public float healAmount = 20;
  boolean hasHealed; 

  public HealthTile(int x, int y){
    super(x, y); 

    image = ResourceManager.getImage("MagmaTile");
  }

  // void mine(boolean playBreakSound){
  //   super.mine(playBreakSound);

  //   if(hasHealed){
  //     return; 
  //   }

  //   hasHealed = true; 
  //   heal(); 
  // }

  // void mine(boolean playBreakSound, boolean doResourceDrop){
  //   super.mine(playBreakSound);
  
  //   if(hasHealed){
  //     return; 
  //   }
  //   hasHealed = true; 

  //   if(doResourceDrop){
  //     heal(); 
  //   }
  // }

  private void heal(){

    player.currentHealth += healAmount; 
  }

}