class BaseObject {
    PVector position = new PVector(0,0);
    PVector size = new PVector(40, 40);
    boolean density = true;
    boolean loadInBack = false; //true to insert at the front of draw, so player doesn't get loaded behind tiles

    void update(){
        return;
    }

    void draw(){
        return;
    }

    void destroyed(){ //this is what you make a child proc from in-case you want to do something special on deletion
        objectList.remove(this);
        return;
    }

    void specialAdd(){ //add to certain lists
        if(loadInBack){
            objectList.add(0, this);
        }
        else {
           objectList.add(this); 
        }
        return;
    }

    boolean canMine(){ //could be useful for attacking
        return false;
    
    }

    void takeDamage(float damageTaken){

    }
}