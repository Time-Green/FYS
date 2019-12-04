class Chest extends Obstacle {
  boolean opened = false;
  int forcedKey = -1; //set to something zero or above if you want a specific set of contents

  float jumpiness = -25; //how far our contents jump out
  float sideWobble = 5; //vertical velocity of item ranging between -sideWobble and sideWobble

  PImage openState = ResourceManager.getImage("ChestOpen");

  ArrayList<Movable> contents = new ArrayList<Movable>();

  Chest(){
    populateContents();
    anchored = false;

    image = ResourceManager.getImage("Chest");
  }

  void populateContents(){ //only load childtypes of Movable
    ArrayList<BaseObject> newContents = new ArrayList<BaseObject>();

    int randomKey = int(random(1, 2));

    if(forcedKey >= 0){
      randomKey = forcedKey;
    }

    switch(randomKey){
      case 1:
        newContents.add(load(new Pickaxe(), new PVector(200, 200)));
        break;
      case 2:
        newContents.add(load(new RelicShard(), new PVector(200, 200)));
        break;
      case 3:
        newContents.add(load(new Dynamite(), new PVector(200, 200)));
        newContents.add(load(new Dynamite(), new PVector(200, 200)));
        newContents.add(load(new Dynamite(), new PVector(200, 200)));
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

  void takeDamage(float damageTaken){
    super.takeDamage(damageTaken);

    delete(this);
  }

  void openChest(){

    AudioManager.playSoundEffect("ChestOpen");

    for(Movable movable : contents){
      movable.moveTo(position.x, position.y - tileHeight);
      movable.suspended = false;

      movable.velocity.y = random(jumpiness / 2, jumpiness);
      movable.velocity.x = random(-sideWobble, sideWobble);
    }

    contents.clear();
    opened = true;
    image = openState;
  }
}