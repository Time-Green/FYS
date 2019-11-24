class AirTile extends Tile{

  AirTile(int x, int y){
    super(x, y);

    density = false;
    destroyedImage = null;
  }

  void takeDamage(float damageTaken){
    super.takeDamage(damageTaken);
  }
}
