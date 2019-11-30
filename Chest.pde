class Chest extends Obstacle {
    boolean opened = false;
    int forcedKey = -1; //set to something zero or above if you want a specific set of contents

    float jumpiness = -10; //how far our contents jump out
    float sideWobble = 2; //vertical velocity of item ranging between -sideWobble and sideWobble

    PImage openState = ResourceManager.getImage("ChestOpen");

    ArrayList<Movable> contents = new ArrayList<Movable>();

    Chest(){
        populateContents();
        anchored = false;

        image = ResourceManager.getImage("Chest");
    }

    void populateContents(){ //only load childtypes of Movable
        ArrayList<BaseObject> newContents = new ArrayList<BaseObject>();

        int randomKey = int(random(0));

        if(forcedKey >= 0){
            randomKey = forcedKey;
        }

        switch(randomKey){
            case 0:
                newContents.add(load(new Pickaxe(), new PVector(200, 200)));
                break;
        }

        for(BaseObject object : newContents){//I dont want to force every new content thingy to Movable seperately, so do it here
            contents.add((Movable) object);
        }

        for(Movable movable : contents){
            movable.suspended = true;
        }
    }

    void pushed(Movable movable, float x, float y){
        super.pushed(movable, x, y);

        if(!opened && movable.canPlayerInteract()){
            openChest();
        }
    }

    void openChest(){
        for(Movable movable : contents){
            movable.moveTo(position.x, position.y - tileHeight);
            movable.suspended = false;

            movable.velocity.y = jumpiness;
            movable.velocity.x = random(-sideWobble, sideWobble);
        }

        contents.clear();
        opened = true;
        image = openState;
    }
}

class StarterChest extends Chest{ //dont tell jordy I put it in the same file

    StarterChest(){
        forcedKey = 1;
    }


}