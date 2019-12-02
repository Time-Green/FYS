class Player extends Mob {

  AnimatedImage animatedImageWalk;
  AnimatedImage animatedImageIdle;
  AnimatedImage animatedImageAir;
  UIController ui;

  PVector spawnPosition = new PVector(1200, 500);
  int score = 0;

  public Player() {

    position = spawnPosition;
    setMaxHp(100);
    baseDamage = 0.1; //low basedamage without pickaxe

    PImage[] walkFrames = new PImage[3];
    PImage[] idleFrames = new PImage[3];
    PImage[] airFrames = new PImage[3];
 
    for(int i = 0; i < 3; i++){
      walkFrames[i] = ResourceManager.getImage("PlayerWalk" + i); 
    }
    animatedImageWalk = new AnimatedImage(walkFrames, 10 - abs(velocity.x), position, size.x, flipSpriteHorizontal);

     for(int i = 0; i < 3; i++){
      idleFrames[i] = ResourceManager.getImage("PlayerIdle" + i); 
    }
    animatedImageIdle = new AnimatedImage(idleFrames, 10 - abs(velocity.x), position, size.x, flipSpriteHorizontal);
      
       for(int i = 0; i < 3; i++){
      airFrames[i] = ResourceManager.getImage("PlayerAir" + i); 
    }
    animatedImageAir = new AnimatedImage(airFrames, 10 - abs(velocity.x), position, size.x, flipSpriteHorizontal);

    //for (int i = 0; i < 3; i++) {
    //  frames[i] = ResourceManager.getImage("PlayerDig" + i);
    //}



    setupLightSource(this, 400f, 1f);
  }

  void update() {

    if (Globals.gamePaused) {  
      return;
    }

    super.update();

    doPlayerMovement();
  }

void draw(){

  if(InputHelper.isKeyDown(Globals.LEFTKEY) || InputHelper.isKeyDown(Globals.RIGHTKEY) || InputHelper.isKeyDown(Globals.DIGKEY)) {
    animatedImageWalk.flipSpriteHorizontal = flipSpriteHorizontal;
    animatedImageWalk.draw();
    //println("walk");
  }
  else if(InputHelper.isKeyDown(Globals.JUMPKEY)) {
    animatedImageAir.flipSpriteHorizontal = flipSpriteHorizontal;
    animatedImageAir.draw();
    //println("jump");
  }
  else {
    animatedImageIdle.flipSpriteHorizontal = flipSpriteHorizontal;
    animatedImageIdle.draw();
    //println("idle");
  }

  for(Item item : inventory){ //player only, because we'll never bother adding a holding sprite for every mob 
    item.drawOnPlayer(this);
  }
}

  void doPlayerMovement() {

    if ((InputHelper.isKeyDown(Globals.JUMPKEY)) && isGrounded()) {
      addForce(new PVector(0, -jumpForce));
    }

    if (InputHelper.isKeyDown(Globals.DIGKEY)) {
      isMiningDown = true;
    } else {
      isMiningDown = false;
    }

    if (InputHelper.isKeyDown(Globals.LEFTKEY)) {
      addForce(new PVector(-speed, 0));
      isMiningLeft = true;
      isMiningRight = false;
      flipSpriteHorizontal = false;
    }

    if (InputHelper.isKeyDown(Globals.RIGHTKEY)) {
      addForce(new PVector(speed, 0));
      isMiningRight = true;
      isMiningLeft = false;
      flipSpriteHorizontal = true;
    } 


    if (InputHelper.isKeyDown(ALT)) { 
      useInventory();
    }

    if (InputHelper.isKeyDown('g')) { //for 'testing'
      load(new Dynamite(), new PVector(position.x + 100, position.y));
    }

    if(InputHelper.isKeyDown('h')) {
      load(new Chest(), new PVector(position.x + 100, position.y));
      InputHelper.onKeyReleased(9999999, 'h'); //ssssh
    }

    if (InputHelper.isKeyDown('z')) { 
      switchInventory();
      InputHelper.onKeyReleased(9999999, 'z'); //ssssh
    }


  }

  void addScore(int scoreToAdd) {
    score += scoreToAdd;
  }

  public void takeDamage(float damageTaken) {

    //println("player took " + damageTaken + " damage");

    if (isImmortal) {

      return;
    }

    if (isHurt == false) {
      // if the player has taken damage, add camera shake
      CameraShaker.induceStress(0.6f);
    }

    //needs to happen after camera shake because else 'isHurt' will be always true
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

  public boolean canPlayerInteract(){
    return true;
  }

}

