public class PickUp extends Movable{
    
    float radius = 30;

    public PickUp (PVector spawnPosition) {
        position.set(spawnPosition);
        size = new PVector(radius, radius);
    }

    void draw(){
        super.draw();
    }

    void update(){
        super.update();
    }

    void pickedUp(BaseObject object){
        delete(this);
    }

    boolean canCollideWith(BaseObject object){
        if(object instanceof Player){ //maybe replace with canPickUp?
            pickedUp(object);
            return false;
        }
        else if(object instanceof PickUp){
            return false;
        }
        return super.canCollideWith(object);
    }
}
