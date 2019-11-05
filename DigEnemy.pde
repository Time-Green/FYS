class DigEnemy extends Enemy {

    DigEnemy() {
        image = ResourceManager.getImage("DigEnemy");
        this.speed = 5;
    }

    void update() {
        super.update();

        if (player.position.x < this.position.x) this.walkLeft = true;
        else this.walkLeft = false;

        if (player.position.y < this.position.y) {
            this.isMiningDown = true;
            //this.isMiningUp = false;
            //gravityForce = 1;
        } else if (player.position.y > this.position.y || player.position.y == this.position.y ) {
            this.isMiningDown = false;
            // gravityForce = -1;
        }

        if (walkLeft) {
            isMiningLeft = true;
            isMiningRight = false;
        } else {
            isMiningLeft = false;
            isMiningRight = true;    
        }
    }
}
