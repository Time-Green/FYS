public class BedrockTile extends Tile{

  public BedrockTile(int x, int y){
    super(x, y);

    maxHp = 9999;
    hp = maxHp;
      
    image = ResourceManager.getImage("BedrockBlock");
    breakSound = ResourceManager.getSound("StoneBreak" + floor(random(1, 5)));
  }

  void update(){
    super.update();

    hp = maxHp;
  }
}
