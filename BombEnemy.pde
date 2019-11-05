class BombEnemy extends Enemy {

    private float explosionRange = 80;
    private PVector exposionSize = new PVector(size.x + explosionRange, size.y + explosionRange);
    
    private boolean isExploding = false;
    float explosionTimer = 1.5f * 60f;
    private boolean isDead = false;
    
    BombEnemy() {
        image = ResourceManager.getImage("BombEnemy");
        this.speed = 2.5f;
    }

    void update(World world) {
        super.update(world);

        if (isExploding == true) {
            this.speed = 0;
            explosionTimer--;
            if (explosionTimer <= 0 && isDead == false) {
                this.size.x = 0;
                world.createExplosion(int(position.x), int(position.y), this);
                this.gravityForce = 0;
                float d = dist(this.position.x, this.position.y, player.position.x, player.position.y);
                if (d <= explosionRange) player.takeDamage(getAttackPower());
                isDead = true;
            }
        }

    }

    protected void handleCollision(){
        super.handleCollision();

        // size.add(explosionRange,explosionRange);
        if (CollisionHelper.rectRect(this.position, exposionSize, player.position, player.size)){
            isExploding = true;
        }
    }
}
