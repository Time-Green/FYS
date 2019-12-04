class Button extends Obstacle{ 
    PImage pressedImage = ResourceManager.getImage("ButtonPressed");
    boolean canBePressed = true;
    
    Button(){
        size.set(50, 10);
        image = ResourceManager.getImage("Button");
    }

    void collidedWith(BaseObject object){
        if(!(object instanceof Movable)){
            anchored = true; //lock into place once we found a floor
            return;
        }
        Movable presser = (Movable) object;

        if(canBePressed && presser.velocity.y > 1){ //someone jumped on us
            image = pressedImage;
            canBePressed = false;
            buttonPressed(presser);
        }
    }

    void buttonPressed(Movable presser){
        startGameSoon();
    }
}