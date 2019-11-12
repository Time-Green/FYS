public class PickUp extends Atom{
    
    float radius = 10;

    public PickUp (PVector spawnPosition) {
        position = spawnPosition.copy();
        size = new PVector(radius, radius);
        atomCollision = true;
    }

    void draw(){
        // super.draw();
        circle(position.x, position.y, radius*2);
    }

    void pushed(Atom atom, float x, float y){

        if(atom instanceof Player){
            pickedUp(atom);
            println("feafesfesf");
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
}
