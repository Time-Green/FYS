class Enemy extends Mob {

    public Enemy(){
        image = ResourceManager.getImage("TestEnemy");
    }

    void update(World world) {
        if (Globals.gamePaused) return;

        super.update(world);

        checkPlayerCollision();
    }

    private void checkPlayerCollision() {

    if (CollisionHelper.rectRect(position, size, player.position, player.size)){
        player.playerHurt();
    }
  }

    

}