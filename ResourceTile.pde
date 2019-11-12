public class ResourceTile extends Tile{

    int value;
    int pickUpDropAmountValue = 5;
    PImage pickUpImage;

    public ResourceTile(int x, int y){
        super(x, y);
    }

    void mine(){
        super.mine();
        for (int i = 0; i < pickUpDropAmountValue; i++) {
            load(new ScorePickUp(new PVector(position.x + 10 + random(size.x - 20), position.y + 10 + random(size.y - 20)), this));
        }
    }

}
