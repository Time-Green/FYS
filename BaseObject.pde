class BaseObject {
    PVector position = new PVector(0,0);
    PVector size = new PVector(40, 40);
    boolean density = true;

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