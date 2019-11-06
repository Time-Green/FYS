class EnemyGhost extends Enemy {

    EnemyGhost() {
        image = ResourceManager.getImage("GhostEnemy");
        collisionEnabled = false;
        gravityForce = 0;
        position = new PVector(1000, 600);
    }
}
