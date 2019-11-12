public class PickUp extends Atom{
    
    float radius = 30;

    public PickUp (PVector spawnPosition) {
        position = spawnPosition.copy();
        size = new PVector(radius, radius);
        atomCollision = true;
    }

    void draw(){
        super.draw();
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
