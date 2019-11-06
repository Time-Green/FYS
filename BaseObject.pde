class BaseObject {
    protected PVector position = new PVector(0,0);
    protected float objectSize = 40f;
    protected PVector size = new PVector(objectSize, objectSize);
    protected boolean density = true;

    void specialDestroy(){ //remove from certain lists
        return;
    }

    void specialAdd(){ //add to certain lists
        return;
    }

    void update(){
        return;
    }

    void draw(){
        return;
    }

    void delete(){
        destroyList.remove(this);
    }

    boolean canMine(){ //could be useful for attacking
        return false;
    
    }

    void takeDamage(float damageTaken){

    }
}