public class MysteryTile extends PowerUpTile {

    public MysteryTile (int x, int y) {

        super(x,y);
        image = ResourceManager.getImage("MysteryBlock");
    }

    void destroy(){
        super.destroy(); 
    }

}
