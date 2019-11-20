class AirTile extends Tile{

  AirTile(int x, int y){
    super(x, y);

    density = false;
  }

  void takeDamage(float damageTaken){
    super.takeDamage(damageTaken);
  }
}
