class EnemyGhost extends Enemy {

    EnemyGhost() {
        image = ResourceManager.getImage("GhostEnemy");
        collisionEnabled = false;
        gravityForce = 0;
        position.set(1000, 2000);
        setupLightSource(this, 200f, 1f);
    }
}
