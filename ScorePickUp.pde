public class ScorePickUp extends PickUp{
    int score;

    public ScorePickUp(ResourceTile tile) {
        score = tile.value / tile.pickUpDropAmountValue;
        image = tile.pickUpImage;
    }

    void pickedUp(Mob mob){
        player.addScore(score);

        super.pickedUp(mob);
    }

    void draw(){
        super.draw();
    }

    void update(){
        super.update();
    }
}
