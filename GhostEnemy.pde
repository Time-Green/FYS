class GhostEnemy extends Enemy {

    GhostEnemy() {
        image = ResourceManager.getImage("GhostEnemy");
        collisionEnabled = false;
        gravityForce = 0;
        this.position = new PVector(1000, 600);
        
    }

}