public class ScorePickUp extends PickUp{
    int score;

    public ScorePickUp(PVector spawnPosition, ResourceTile tile) {
        super(spawnPosition);
        score = tile.value / tile.pickUpDropAmountValue;
        image = tile.pickUpImage;
    }

    void pickedUp(BaseObject object){
        player.addScore(score);

        super.pickedUp(object);
    }

    void draw(){
        super.draw();
    }

    void update(){
        super.update();
    }
}
