class Player extends Mob {

  //AnimatedImage animatedImageLeft;
  //AnimatedImage animatedImageDig;
  //AnimatedImage animatedImageJump;

  PVector spawnPosition = new PVector(1200, 500);
  int score = 0;

  public Player() {

    image = ResourceManager.getImage("Player");
    position = spawnPosition;
    setMaxHp(15);

    //PImage[] frames1 = new PImage[3];
    //PImage[] frames2 = new PImage[3];
    //PImage[] frames3 = new PImage[3];

    //for (int i = 0; i < 3; i++) {
    //  frames1[i] = ResourceManager.getImage("PlayerLeft" + i);
    //}

    //for (int i = 0; i < 3; i++) {
    //  frames2[i] = ResourceManager.getImage("PlayerDig" + i);
    //}

    //for (int i = 0; i < 3; i++) {
    //  frames3[i] = ResourceManager.getImage("PlayerJump" + i);
    //}

    ////animation speed based on x velocity
    //animatedImageLeft = new AnimatedImage(frames1, 20 - abs(velocity.x));
    //animatedImageDig = new AnimatedImage(frames2, 20 - abs(velocity.x));
    //animatedImageJump = new AnimatedImage(frames3, 20 - abs(velocity.x));
    //}

  setupLightSource(this, 600f, 1f);
}

void update() {

  if (Globals.gamePaused) {  
    return;
  }

  super.update();

  doPlayerMovement();
}

void doPlayerMovement() {

  if ((InputHelper.isKeyDown(UP) || controller.isButtonDown("BOTTOM")) && isGrounded()) {
    addForce(new PVector(0, -jumpForce));
    //animatedImageJump.draw();
  }

  if (InputHelper.isKeyDown(DOWN) || controller.isSliderDown("YPAD", false)) {
    isMiningDown = true;
    //animatedImageDig.draw();
  } else {
    isMiningDown = false;
  }

  if (InputHelper.isKeyDown(LEFT) || controller.isSliderDown("XPAD", true)) {
    addForce(new PVector(-speed, 0));
    isMiningLeft = true;
    flipSpriteHorizontal = false;
   // animatedImageLeft.draw();
  } else {
    isMiningLeft = false;
  }

  if (InputHelper.isKeyDown(RIGHT) || controller.isSliderDown("XPAD", false)) {
    addForce(new PVector(speed, 0));
    isMiningRight = true;
    flipSpriteHorizontal = true;
    //animatedImageLeft.draw();
  } else {
    isMiningRight = false;
  }
  if (InputHelper.isKeyDown(' ')) { 
    useInventory();
  }
  if (InputHelper.isKeyDown('g')) { //for 'testing'
    load(new Dynamite(), new PVector(position.x + 100, position.y));
  }

  if ()
}

void addScore(int scoreToAdd) {
  score += scoreToAdd;
}

public void takeDamage(int damageTaken) {

  if (isImmortal) {

    return;
  }

  if (isHurt == false) {
    // if the player has taken damage, add camera shake
    CameraShaker.induceStress(0.6f);
  }

  //needs to happan after camera shake because else 'isHurt' will be always true
  super.takeDamage(damageTaken);
}

public void die() {
  super.die();

  Globals.gamePaused = true;
  Globals.currentGameState = Globals.GameState.GameOver;
}

boolean canPickUp(PickUp pickUp) {
  return true;
}
}
