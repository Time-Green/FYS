class Player extends Mob {

  PVector spawnPosition = new PVector(1200, 500);
  int score = 0;

  public Player(){
    
    image = ResourceManager.getImage("Player");
    position = spawnPosition;
    setMaxHp(15);

    setupLightSource(this, 600f, 1f);
  }

  void update(){

    if(Globals.gamePaused){  
      return;
    }
    
    super.update();

    doPlayerMovement();

  }
  
  void doPlayerMovement(){

    if((InputHelper.isKeyDown(Globals.JUMPKEY)) && isGrounded()){
      addForce(new PVector(0, -jumpForce));
    }

    if(InputHelper.isKeyDown(Globals.DIGKEY)){
      isMiningDown = true;
    }else{
      isMiningDown = false;
    }

    if(InputHelper.isKeyDown(Globals.LEFTKEY)){
      addForce(new PVector(-speed, 0));
      isMiningLeft = true;
    }else{
      isMiningLeft = false;
    }

    if(InputHelper.isKeyDown(Globals.RIGHTKEY)){
      addForce(new PVector(speed, 0));
      isMiningRight = true;
    }else{
      isMiningRight = false;
    }

    if(InputHelper.isKeyDown(' ')){ 
      useInventory();
    }

    if(InputHelper.isKeyDown('g')){ //for 'testing'
      load(new Dynamite(), new PVector(position.x + 100, position.y));
    }
  }

  void addScore(int scoreToAdd){
    score += scoreToAdd;
  }

  public void takeDamage(int damageTaken){

    if(isImmortal){
    
      return;         
    }

    if(isHurt == false){
      // if the player has taken damage, add camera shake
      CameraShaker.induceStress(0.6f);
    }

    //needs to happan after camera shake because else 'isHurt' will be always true
    super.takeDamage(damageTaken);
  }

  public void die(){
    super.die();

    Globals.gamePaused = true;
    Globals.currentGameState = Globals.GameState.GameOver;
  }

  boolean canPickUp(PickUp pickUp){
    return true;
  }
}
