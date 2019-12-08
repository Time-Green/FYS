class Dynamite extends Item {
  int explosionSize = 400;

  Dynamite() {
    image = ResourceManager.getImage("Dynamite"); //not actually dynamite ssssh
  }

  void collidedWith(BaseObject object) {
    if (thrower != null) { //someone threw us and we hit something so its kaboom time
      load(new Explosion(position, explosionSize, 5, false));
      delete(this);
    }
  }
}
