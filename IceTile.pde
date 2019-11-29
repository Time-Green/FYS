public class IceTile extends ResourceTile{

  public IceTile(int x, int y){
    super(x, y);

    value = 500;
    
    image = ResourceManager.getImage("IceBlock");
    breakSound = ResourceManager.getSound("StoneBreak" + floor(random(1, 5)));
    pickUpImage = ResourceManager.getImage("GoldPickUp");
  }

  void takeDamage(float damageTaken){
    super.takeDamage(damageTaken);
  }
}
