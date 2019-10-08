class WallOfDeath {

  private float wallX = 0,wallY = -100;
  private float wallWidth, wallHeight = 200;
  private float moveSpeed = 1f;

  color wallColor = #FF8C33;

  WallOfDeath() {
    //Make the widtg of the wall the same as the screen width
    wallWidth = width;
  }

  void draw() {
    fill(wallColor);
    rect(wallX, wallY,wallWidth, wallHeight);
  }

  void update() {
    wallY += moveSpeed;
  }

  boolean rectRect() {

    // are the sides of one rectangle touching the other?
    if (wallX + wallWidth >= user.position.x &&    // r1 right edge past r2 left
        wallX <= user.position.x + user.size.x &&    // r1 left edge past r2 right
        wallY + wallHeight >= user.position.y &&    // r1 top edge past r2 bottom
        wallY <= user.position.y + user.size.y) {    // r1 bottom edge past r2 top
          return true;
    }
    return false;
  }

}
