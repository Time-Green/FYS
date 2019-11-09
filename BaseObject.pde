class BaseObject {

    protected PVector position = new PVector(0,0);
    protected final float OBJECTSIZE = 40f;
    protected PVector size = new PVector(OBJECTSIZE, OBJECTSIZE);
    protected boolean density = true;
    protected boolean loadInBack = false; //true to insert at the front of draw, so player doesn't get loaded behind tiles
    protected boolean atomCollision = false; //do we collide with atoms themselves?

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

    void takeDamage(int damageTaken){
        return;
    }

    void pushed(Atom atom, float x, float y){ //we got pushed by an atom
        return;
    }
}