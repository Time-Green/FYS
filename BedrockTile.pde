public class BedrockTile extends Tile{

    public BedrockTile(int x, int y){
      super(x, y);
      
      image = ResourceManager.getImage("BedrockBlock");
      breakSound = ResourceManager.getSound("StoneBreak" + floor(random(1, 5)));
    }

}
