class Button extends Obstacle{ 
    PImage pressedImage = ResourceManager.getImage("ButtonPressed");
    boolean canBePressed = true;
    
    Button(){
        size.set(50, 10);
        image = ResourceManager.getImage("Button");
    }

    void pushed(Mob mob, PVector otherPosition){

        if(otherPosition.y > 0){ //someone jumped on us
            image = pressedImage;
            canBePressed = false;
            buttonPressed(mob);
        }
    }

    void buttonPressed(Mob movable){
        Globals.isInOverWorld = false;
        startGame(true); 
    }
}