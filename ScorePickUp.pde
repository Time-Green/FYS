public class ScorePickUp extends PickUp{
    int score;

    public ScorePickUp(PVector spawnPosition, ResourceTile tile) {
        super(spawnPosition);
        score = tile.value / tile.pickUpDropAmountValue;
        image = tile.pickUpImage;
    }

    void pickedUp(Atom atom){
        player.addScore(score);

        super.pickedUp(atom);
    }

    void draw(){
        super.draw();
    }

    void update(){
        super.update();
    }
}
