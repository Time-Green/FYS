class Button extends Obstacle { 
  PImage pressedImage = ResourceManager.getImage("ButtonPressed");
  boolean canBePressed = true;

  Button() {
    size.set(50, 10);
    image = ResourceManager.getImage("Button");
  }

  void update() {
    super.update();

    if (canBePressed) {
      drawText();
    }
  }

  void drawText() {
    textAlign(CENTER);
    textSize(20);
    fill(#ffa259);

    text("Caution\nDo NOT press!!!", position.x + 20, position.y - 65);

    textAlign(LEFT);
  }

  void collidedWith(BaseObject object) {
    if (!(object instanceof Movable)) {
      //anchored = true; //lock into place once we found a floor
      anchoredHorizontaly = true;

      return;
    }

    Movable presser = (Movable) object;

    if (canBePressed && presser.velocity.y > 1) { //someone jumped on us
      image = pressedImage;
      canBePressed = false;
      buttonPressed(presser);
    }
  }

  void buttonPressed(Movable presser) {
    startGameSoon();
  }

  void takeDamage(float damageTaken) {
    super.takeDamage(damageTaken);

    delete(this);
  }
}
