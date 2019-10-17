class Atom {
  PVector position = new PVector(100, 300);
  PVector size = new PVector(40, 40);
  PVector velocity = new PVector();
  PVector acceleration = new PVector();
  color atomColor = color(255, 0, 0);
  float atomSpeed = 2f;
  float jumpForce = 20f;
  float gravityForce = 1f;
  float dragFactor = 0.95f;
  boolean isGrounded, isMiningDown, isMiningLeft, isMiningRight;
  boolean collisionEnabled = true;

  void update() {
    prepareMovement();
    isGrounded = false;

    if (collisionEnabled) {

      if (checkCollision(0, velocity.y)) { //up
        velocity.y = max(velocity.y, 0);
      }

      if (checkCollision(0, velocity.y)) { //down
        velocity.y = min(velocity.y, 0);
        isGrounded = true;
      }
      if (checkCollision(velocity.x, 0)) { //horizontal
        velocity.x = 0;
      }
    }

    handleMovement();
  }

  void draw() {
    fill(atomColor);
    rect(position.x, position.y, size.x, size.y);
  }

  private void prepareMovement() {
    //gravity
    acceleration.add(new PVector(0, gravityForce));

    velocity.add(acceleration);
    acceleration.mult(0);

    //velocity.limit(15); //max speed
    velocity.mult(dragFactor); //drag
  }

  private void handleMovement() {
    position.add(velocity);

    position.x = constrain(position.x, 0, tilesHorizontal * tileWidth + 10);
  }

  boolean isGrounded() {
    return isGrounded;
  }

  void addForce(PVector forceToAdd) { //amount of pixels we move
    acceleration.add(forceToAdd);
  }

  void setForce(PVector newForce) {
    acceleration = newForce;
  }

  boolean checkCollision(float maybeX, float maybeY) {
    for (Tile tile : getSurroundingTiles(int(position.x), int(position.y), this)) {
      if (!tile.isSolid) {
        continue;
      }

      collisionDebug(tile);

      if (CollisionHelper.rectRect(position.x + maybeX, position.y + maybeY, size.x, size.y, tile.position.x, tile.position.y, tileWidth, tileHeight)) {

        if (isMiningDown) {
          tile.takeDamage(1);
        }

        return true;
      }
    }
    return false;
  }

  private void collisionDebug(Tile tile) {
    fill(255, 0, 0);
    rect(tile.position.x, tile.position.y, tileWidth, tileHeight);
  }
}
