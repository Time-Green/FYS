class Player extends Mob {

  //Animation
  private AnimatedImage walkCycle;
  private final int WALKFRAMES = 4;
  private AnimatedImage animatedImageIdle;
  private final int IDLEFRAMES = 3;
  private AnimatedImage animatedImageAir;
  private final int AIRFRAMES = 3;
  private AnimatedImage shockedCycle;
  private final int SHOCKFRAMES = 2;
  private AnimatedImage animatedImageMine;
  private final int MINEFRAMES = 3;
  private AnimatedImage animatedImageFall;
  private final int FALLFRAMES = 4;

  private float VIEW_AMOUNT = 400;
  private float viewTarget;
  private float easing = 0.025f;

  private float regen = 0.2f;

  //Status effects
  public float stunTimer;

  PVector spawnPosition = new PVector(1300, 509);
  int score = 0;

  public Player() {
    position = spawnPosition;
    setMaxHp(100);
    baseDamage = 0.1; //low basedamage without pickaxe
    viewTarget = VIEW_AMOUNT;
    isSwimming = false;

    PImage[] walkFrames = new PImage[WALKFRAMES];
    PImage[] idleFrames = new PImage[IDLEFRAMES];
    PImage[] airFrames = new PImage[AIRFRAMES];
    PImage[] mineFrames = new PImage[MINEFRAMES];
    PImage[] shockFrames = new PImage[SHOCKFRAMES];
    PImage[] fallFrames = new PImage[FALLFRAMES];

    for (int i = 0; i < WALKFRAMES; i++)
      walkFrames[i] = ResourceManager.getImage("PlayerWalk" + i); 
    walkCycle = new AnimatedImage(walkFrames, 10 - abs(velocity.x), position, size.x, flipSpriteHorizontal);

    for (int i = 0; i < IDLEFRAMES; i++)
      idleFrames[i] = ResourceManager.getImage("PlayerIdle" + i); 
    animatedImageIdle = new AnimatedImage(idleFrames, 60 - abs(velocity.x), position, size.x, flipSpriteHorizontal);

    for (int i = 0; i < AIRFRAMES; i++)
      airFrames[i] = ResourceManager.getImage("PlayerAir" + i); 
    animatedImageAir = new AnimatedImage(airFrames, 10 - abs(velocity.x), position, size.x, flipSpriteHorizontal);

    for (int i = 0; i < SHOCKFRAMES; i++)
      shockFrames[i] = ResourceManager.getImage("PlayerShock" + i); 
    shockedCycle = new AnimatedImage(shockFrames, 10 - abs(velocity.x), position, size.x, flipSpriteHorizontal);

    for (int i = 0; i < MINEFRAMES; i++) 
      mineFrames[i] = ResourceManager.getImage("PlayerMine" + i);
    animatedImageMine = new AnimatedImage(mineFrames, 5 - abs(velocity.x), position, size.x, flipSpriteHorizontal);

    for (int i = 0; i < FALLFRAMES; i++) 
      fallFrames[i] = ResourceManager.getImage("PlayerFall" + i);
    animatedImageFall = new AnimatedImage(fallFrames, 20 - abs(velocity.x), position, size.x, flipSpriteHorizontal);

    setupLightSource(this, VIEW_AMOUNT, 1f);

    applyRelicBoost();

  }

  void update() {

    if (Globals.gamePaused) {  
      return;
    }

    super.update();

    setVisibilityBasedOnCurrentBiome();

    regenaration();

    checkHealthLow();

    statusEffects();

    if (stunTimer <= 0) {
      doPlayerMovement();
    }
  }

  void checkHealthLow() {
    if (currentHealth < maxHealth / 5f && currentHealth > maxHealth / 10f) { // if lower than 20% health, show low health overlay

      ui.drawWarningOverlay = true;

       if (frameCount % 60 == 0) {
        AudioManager.playSoundEffect("LowHealth");
      }

      }else if (currentHealth < maxHealth / 10f) { // if lower than 10% health, show low health overlay intesified

      ui.drawWarningOverlay = true;

       if (frameCount % 40 == 0) {
        AudioManager.playSoundEffect("LowHealth");
      }

      } else if (currentHealth > maxHealth / 5f) {

      ui.drawWarningOverlay = false;
    }
  }


  void regenaration() {
     if(isHurt == false) {
      if(currentHealth < maxHealth) {
        if(frameCount % 5 == 0) {
          currentHealth += regen;
          }
        }
      }  
      else if(isHurt == true) { // there is a 2 second timer before the player starts to regenarate if hit
        if(currentHealth < maxHealth) {
          if(frameCount % 120 == 0)  {
            if(frameCount % 5 == 0) {
              currentHealth += regen;
            }
          }
        }
      }
  }

  void applyRelicBoost(){
    for(PlayerRelicInventory collectedRelicShardInventory : totalCollectedRelicShards) {

      if(collectedRelicShardInventory.relicshardid == 0) {
        baseDamage += Globals.DAMAGE_BOOST * getRelicStrength(collectedRelicShardInventory.amount);
      }
      else if(collectedRelicShardInventory.relicshardid == 1) {
         maxHealth += Globals.HEALTH_BOOST * getRelicStrength(collectedRelicShardInventory.amount);
         currentHealth += Globals.HEALTH_BOOST * getRelicStrength(collectedRelicShardInventory.amount);
      }
      else if(collectedRelicShardInventory.relicshardid == 2) {
        regen += Globals.REGEN_BOOST * getRelicStrength(collectedRelicShardInventory.amount);
      }
      else if(collectedRelicShardInventory.relicshardid == 3) {
        this.speed += Globals.SPEED_BOOST * getRelicStrength(collectedRelicShardInventory.amount);
      }
      else if(collectedRelicShardInventory.relicshardid == 4) {
        VIEW_AMOUNT += Globals.LIGHT_BOOST * getRelicStrength(collectedRelicShardInventory.amount);
      }
    }
  }

  float getRelicStrength(float relicAmount){
    return floor(relicAmount/5);
  }

  void setVisibilityBasedOnCurrentBiome() {

    if (getDepth() > world.currentBiome.startedAt) {

      if (world.currentBiome.playerVisibility > 0) {
        viewTarget = world.currentBiome.playerVisibility;
      } else {
        viewTarget = VIEW_AMOUNT;
      }
    }

    float dy = viewTarget - lightEmitAmount;
    lightEmitAmount += dy * easing;
  }

  void draw() {

    if(Globals.gamePaused){
      animatedImageIdle.flipSpriteHorizontal = flipSpriteHorizontal;
      animatedImageIdle.draw();

      return;
    }

    //Animation
    if (stunTimer > 0f) {//Am I stunned?
      shockedCycle.flipSpriteHorizontal = flipSpriteHorizontal;
      shockedCycle.draw();
    } else {//Play the other animations when we are not
      //PLayer input
      if ((InputHelper.isKeyDown(Globals.LEFTKEY) || InputHelper.isKeyDown(Globals.RIGHTKEY)) && isGrounded()) {//Walking
        walkCycle.flipSpriteHorizontal = flipSpriteHorizontal;
        walkCycle.draw();
      } else if ((InputHelper.isKeyDown(Globals.JUMPKEY1) || InputHelper.isKeyDown(Globals.JUMPKEY2))) {//Jumping
        animatedImageAir.flipSpriteHorizontal = flipSpriteHorizontal;
        animatedImageAir.draw();
      } else if (InputHelper.isKeyDown(Globals.DIGKEY) && Globals.currentGameState == Globals.GameState.InGame) {//Digging
        animatedImageMine.flipSpriteHorizontal = flipSpriteHorizontal;
        animatedImageMine.draw();
      } else if(isGrounded == false) {
        animatedImageFall.flipSpriteHorizontal = flipSpriteHorizontal;
        animatedImageFall.draw();
      } else {//Idle
        animatedImageIdle.flipSpriteHorizontal = flipSpriteHorizontal;
        animatedImageIdle.draw();
      }

      for (Item item : inventory) { //player only, because we'll never bother adding a holding sprite for every mob 
        item.drawOnPlayer(this);
      }
    }
  }

  void doPlayerMovement() {

    if (isSwimming)isGrounded = true;

    if ((InputHelper.isKeyDown(Globals.JUMPKEY1) || InputHelper.isKeyDown(Globals.JUMPKEY2)) && isGrounded()) {
      addForce(new PVector(0, -jumpForce));
    }

    if (InputHelper.isKeyDown(Globals.DIGKEY)) {
      isMiningDown = true;
      if (isSwimming) addForce(new PVector(0, (jumpForce/5)));
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

    if (InputHelper.isKeyDown(Globals.INVENTORYKEY)) { 
      useInventory();
      InputHelper.onKeyReleased(Globals.INVENTORYKEY);
    }

    if (InputHelper.isKeyDown('g')) { //for 'testing'
      load(new Dynamite(), new PVector(position.x + 100, position.y));
      InputHelper.onKeyReleased('g');
    }

    if (InputHelper.isKeyDown('h')) {
      load(new Spike(), new PVector(position.x + 100, position.y));
      InputHelper.onKeyReleased('h'); //ssssh
    }

    if (InputHelper.isKeyDown(Globals.ITEMKEY)) { 
      switchInventory();
      InputHelper.onKeyReleased(Globals.ITEMKEY); //ssssh
    }
    if (InputHelper.isKeyDown('i')) { 
      load(new Icicle(), new PVector (player.position.x + 200, player.position.y - 200));
      InputHelper.onKeyReleased('i'); //ssssh
    }
  }

  void addScore(int scoreToAdd) {
    score += scoreToAdd;
  }

  public void takeDamage(float damageTaken) {

    if (isImmortal || damageTaken == 0.0) {
      return;
    }

    if (isHurt == false) {
      // if the player has taken damage, add camera shake
      //40 is about max damage
      CameraShaker.induceStress(damageTaken / 40);

      AudioManager.playSoundEffect("HurtSound");
    }

    //needs to happen after camera shake because else 'isHurt' will be always true
    super.takeDamage(damageTaken);  
  }

  private void statusEffects() {
    //Decrease stun timer
    if (stunTimer > 0f) {
      stunTimer--;
      isMiningDown = false;
      isMiningLeft = false;
      isMiningRight = false;
    }
  }

  public void die() {
    super.die();

    Globals.gamePaused = true;
    Globals.currentGameState = Globals.GameState.GameOver;

    ui.drawWarningOverlay = false;
    AudioManager.stopMusic("BackgroundMusic");

    thread("startRegisterEndThread");
  }

  boolean canPickUp(PickUp pickUp) {
    return true;
  }

  public boolean canPlayerInteract() {
    return true;
  }

  void afterMine(BaseObject object){
    runData.playerBlocksMined++;
  }
}
