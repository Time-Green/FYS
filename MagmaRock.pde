class MagmaRock extends Tile {
  float damage = 10;

  MagmaRock(int x, int y) {    
    super(x, y);

    setupLightSource(this, 300, 1f);
    image = ResourceManager.getImage("LavaBlock");

    slipperiness = 0.1;
    healthMultiplier = 3f;
    //setMaxHp(50);
  }

  void collidedWith(BaseObject object) {
    object.takeDamage(damage);

    if(object instanceof Mob) {
      Mob mob = (Mob) object;

      mob.setOnFire();
    }
  }
}
