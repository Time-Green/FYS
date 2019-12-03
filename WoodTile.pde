public class WoodTile extends Tile{

  public WoodTile(int x, int y){
    super(x, y);

    image = ResourceManager.getImage("Wood");
    this.density = false; 
    destroyedImage = null;  
  }

}
