public class ObsedianTile extends Tile{

  public ObsedianTile(int x, int y){
    super(x, y);

    setMaxHp(2);
      
    image = ResourceManager.getImage("ObsedianBlock");
    breakSound = ResourceManager.getSound("StoneBreak" + floor(random(1, 5)));
  }

  void update(){
    super.update();

    //keep health at 2 so the player can't mine it
    setMaxHp(2);
  }
}
