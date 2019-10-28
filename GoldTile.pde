public class GoldTile extends ResourceTile{

    public GoldTile(int x, int y){
      super(x, y);

      value = 500;
      
      image = ResourceManager.getImage("GoldBlock");
      breakSound = ResourceManager.getSound("StoneBreak" + floor(random(1, 5)));
    }

    void destroy(){
      super.destroy();

      giveScoreToPlayer();
    }
}