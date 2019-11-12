public class PickUp extends Atom{
    
    float radius = 10;

    public PickUp (PVector spawnPosition) {
        position = spawnPosition.copy();
        size = new PVector(radius, radius);
        atomCollision = true;
    }

    void draw(){
        // super.draw();
        fill(lightningAmount);
        circle(position.x, position.y, radius*2);
        fill(255);
    }

    void update(){
        super.update();
    }

    void pushed(Atom atom, float x, float y){

        if(atom instanceof Player){
            pickedUp(atom);
        }

    }

    void pickedUp(Atom atom){
        delete(this);
    }

}

public class ScorePickUp extends PickUp{
    int score;

    public ScorePickUp(PVector spawnPosition, ResourceTile tile) {
        super(spawnPosition);
        score = tile.value / tile.pickUpDropAmountValue;
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
