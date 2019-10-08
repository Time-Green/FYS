class WallOfDeath extends Atom{

  private float moveSpeed = 1f;
  private float wallHeight = 200;
  private float wallY = -100;

  color wallColor = #FF8C33;

  WallOfDeath(float wallWidth) {
    size = new PVector(wallWidth, 200);
    position = new PVector(0, wallY);
  }

  void update() {
    position.y += moveSpeed;
  }

  void draw() {
    fill(wallColor);
    rect(position.x, position.y, size.x, size.y);
    fill(255);
  }
}
