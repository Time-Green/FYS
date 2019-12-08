class MagmaRock extends Tile {
  float damage = 20;

  MagmaRock(int x, int y) {    
    super(x, y);

    setupLightSource(this, 300, 1f);
    image = ResourceManager.getImage("LavaBlock");

    slipperiness = 0.1;
    setMaxHp(50);
  }

  void collidedWith(BaseObject object) {
    object.takeDamage(damage);
  }
}
