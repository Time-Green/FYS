class AirTile extends Tile{

  AirTile(int x, int y){
    super(x, y);

    name = "AirTile[" + x + "," + y + "]";
    
    density = false;
  }
}
