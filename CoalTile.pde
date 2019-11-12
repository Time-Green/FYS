public class CoalTile extends ResourceTile{

    public CoalTile(int x, int y){
      super(x, y);

      value = 50;

      image = ResourceManager.getImage("CoalBlock");
      breakSound = ResourceManager.getSound("StoneBreak" + floor(random(1, 5)));
      pickUpImage = ResourceManager.getImage("IronPickUp");
    }
}
