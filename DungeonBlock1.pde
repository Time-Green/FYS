class DungeonBlock1 extends Tile{

    DungeonBlock1(int x, int y){
        super(x, y);
        image = ResourceManager.getImage("DungeonBlock1");
        setMaxHp(99999);
    }
}