public class IronTile extends ResourceTile{

  public IronTile(int x, int y){
    super(x, y);

    value = 100;

    image = ResourceManager.getImage("IronBlock");
    breakSound = ResourceManager.getSound("StoneBreak" + floor(random(1, 5)));
    pickUpImage = ResourceManager.getImage("IronPickUp");
  }

  void takeDamage(float damageTaken){
    super.takeDamage(damageTaken);
  }
}
