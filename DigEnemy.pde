class DigEnemy extends Enemy {

    DigEnemy() {
        image = ResourceManager.getImage("DigEnemy");
        this.speed = 10;
    }

    void update() {
        super.update();

        if (walkLeft) {
            isMiningLeft = true;
            isMiningRight = false;
        } else {
            isMiningLeft = false;
            isMiningRight = true;    
        }
    }
}
