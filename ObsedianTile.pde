public class ObsedianTile extends Tile{

  public ObsedianTile(int x, int y){
    super(x, y);

    setMaxHp(9999);
      
    image = ResourceManager.getImage("ObsedianBlock");
    breakSound = ResourceManager.getSound("StoneBreak" + floor(random(1, 5)));
  }

  void update(){
    super.update();

    setMaxHp(9999);
  }
}
