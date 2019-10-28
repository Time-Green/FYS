public class DirtTile extends Tile{

    public DirtTile(int x, int y){
      super(x, y);
      
      image = ResourceManager.getImage("DirtBlock");
      breakSound = ResourceManager.getSound("DirtBreak"); 
    }

}