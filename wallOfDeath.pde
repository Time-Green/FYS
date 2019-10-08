class WallOfDeath extends Atom{

  private float moveSpeed = 1f;
  private float wallHeight = 200;
  private float wallY = -100;

  color wallColor = #FF8C33;

  WallOfDeath(float wallWidth) {
    gravityForce = 0f;
    dragFactor = 1f;
    collisionEnabled = false;
    size = new PVector(wallWidth, 200);
    position = new PVector(0, wallY);
    velocity = new PVector(0, moveSpeed);
  }

  void update() {
    super.update();
  }

  void draw() {
    fill(wallColor);
    rect(position.x, position.y, size.x, size.y);
    fill(255);
  }
}
