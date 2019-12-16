public class DirtTile extends Tile {

  public DirtTile(int x, int y) {
    super(x, y);

    healthMultiplier = 0.5f;
    //setMaxHp(2);

    image = ResourceManager.getImage("DirtBlock");
    breakSound = "DirtBreak";
  }
}
