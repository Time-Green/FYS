class Spike extends Obstacle {

  Spike() {
    size.set(10, 50);
    image = ResourceManager.getImage("Spike");
    anchored = true;
  }

  void pushed(Movable movable, float x, float y) {

    if (y > 0) { //we got hit by downward velocity, so someone fell on us
      movable.takeDamage(1f);
    }
  }
}
