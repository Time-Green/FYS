class Player extends Mob {

  AnimatedImage animatedImageWalk;

  PVector spawnPosition = new PVector(1200, 500);
  int score = 0;

  public Player() {

      //image = ResourceManager.getImage("PlayerWalk0");
  //image = ResourceManager.getImage("PlayerIdle");

    position = spawnPosition;
    setMaxHp(100);

      if(InputHelper.isKeyDown(Globals.LEFTKEY)) {
      flipSpriteHorizontal = false;
    }
     if(InputHelper.isKeyDown(Globals.RIGHTKEY)) {
         flipSpriteHorizontal = true;
       }

    PImage[] frames = new PImage[3];
 
    for(int i = 0; i < 3; i++){
      frames[i] = ResourceManager.getImage("PlayerWalk" + i); 
    }
    animatedImageWalk = new AnimatedImage(frames, 10 - abs(velocity.x), position, flipSpriteHorizontal);
      

    //for (int i = 0; i < 3; i++) {
    //  frames[i] = ResourceManager.getImage("PlayerDig" + i);
    //}

    //for (int i = 0; i < 3; i++) {
    //  frames[i] = ResourceManager.getImage("PlayerJump" + i);
    //}

    ////animation speed based on x velocity
    //animatedImageLeft = new AnimatedImage(frames1, 20 - abs(velocity.x));
    //animatedImageDig = new AnimatedImage(frames2, 20 - abs(velocity.x));
    //animatedImageJump = new AnimatedImage(frames3, 20 - abs(velocity.x));
    //}

    setupLightSource(this, 400f, 1f);
  }

  void draw(){
      	animatedImageWalk.draw();
    }

  void update() {

    if (Globals.gamePaused) {  
      return;
    }

    super.update();

    doPlayerMovement();
  }

  void doPlayerMovement() {

    if ((InputHelper.isKeyDown(Globals.JUMPKEY)) && isGrounded()) {
      addForce(new PVector(0, -jumpForce));
      image = ResourceManager.getImage("PlayerIdle");
    }

    if (InputHelper.isKeyDown(Globals.DIGKEY)) {
      isMiningDown = true;
      //animatedImageDig.draw();
    } else {
      isMiningDown = false;
    }

    if (InputHelper.isKeyDown(Globals.LEFTKEY)) {
      addForce(new PVector(-speed, 0));
      isMiningLeft = true;
      isMiningRight = false;
      flipSpriteHorizontal = false;
      image = ResourceManager.getImage("PlayerWalk0");
      // animatedImageLeft.draw();
    }

    if (InputHelper.isKeyDown(Globals.RIGHTKEY)) {
      addForce(new PVector(speed, 0));
      isMiningRight = true;
      isMiningLeft = false;
      flipSpriteHorizontal = true;
      image = ResourceManager.getImage("PlayerWalk0");
      //animatedImageLeft.draw();
    } 


    if (InputHelper.isKeyDown(' ')) { 
      useInventory();
    }

    if (InputHelper.isKeyDown('g')) { //for 'testing'
      load(new Dynamite(), new PVector(position.x + 100, position.y));
    }

    if(InputHelper.isKeyDown('h')) {
      load(new Held(), new PVector(position.x + 100, position.y));
    }

  }

  void addScore(int scoreToAdd) {
    score += scoreToAdd;
  }

  public void takeDamage(int damageTaken) {

    println("player took " + damageTaken + " damage");

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

