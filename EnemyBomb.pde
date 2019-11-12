class EnemyBomb extends Enemy {

    private float explosionRange = 80;
    private PVector explosionSize = new PVector(size.x + explosionRange, size.y + explosionRange);
    
    private boolean isExploding = false;
    private float explosionTimer = 1.5f * 60f;
    
    EnemyBomb() {
        image = ResourceManager.getImage("BombEnemy");
        this.speed = 2.5f;
    }

    void update() {
        super.update();

        if (isExploding == true) {
            this.speed = 0;
            explosionTimer--;
            if (explosionTimer <= 0) {
                load(new Explosion(position, 4000));
                //world.createExplosion(int(position.x), int(position.y), this);
                float d = dist(this.position.x, this.position.y, player.position.x, player.position.y);
                if (d <= explosionRange) player.takeDamage(getAttackPower());
                delete(this);
            }
            
        }

    }

    protected void handleCollision(){
        super.handleCollision();

        if (CollisionHelper.rectRect(this.position, explosionSize, player.position, player.size)){
            isExploding = true;
        }
    }
}
