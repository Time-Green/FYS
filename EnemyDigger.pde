class EnemyDigger extends Enemy {

    private float chaseDistance;
    private boolean chasePlayer;
    private float resetSpeed = 5f;

    EnemyDigger() {
        image = ResourceManager.getImage("DigEnemy");
        this.speed = resetSpeed;
        //1f = 1 tile
        float tileDistance = 10f;
        chaseDistance = objectSize * tileDistance;
    }

    void update() {
        super.update();

        float distanceToPlayer = dist(this.position.x, this.position.y, player.position.x, player.position.y);
        if (distanceToPlayer <= chaseDistance) {
            
            this.speed = resetSpeed;
            //Chase the player
            if (player.position.x < this.position.x) this.walkLeft = true;
            else this.walkLeft = false;

            if (this.walkLeft) {
                this.isMiningLeft = true;
                this.isMiningRight = false;
            } else {
                this.isMiningLeft = false;
                this.isMiningRight = true;    
            }

            if (player.position.y > this.position.y) {
                this.isMiningDown = true;
            } else {
                this.isMiningDown = false;
            }

        } else {
            //Don't chase the player
            this.speed = 0;
            this.isMiningDown = false;
        }

        println("isMiningDown: "+isMiningDown);

    }
}
