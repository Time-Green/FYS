class Player extends Mob {

  PVector spawnPosition = new PVector(1200, 500);
  int score = 0;

  public Player(){
    name = "Player";
    image = ResourceManager.getImage("player");
    position = spawnPosition;

    isImmortal = true;

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

    if(InputHelper.isKeyDown(UP) && isGrounded()){
      addForce(new PVector(0, -jumpForce));
    }

    if(InputHelper.isKeyDown(DOWN)){
      isMiningDown = true;
    }else{
      isMiningDown = false;
    }

    if(InputHelper.isKeyDown(LEFT)){
      addForce(new PVector(-speed, 0));
      isMiningLeft = true;
    }else{
      isMiningLeft = false;
    }

    if(InputHelper.isKeyDown(RIGHT)){
      addForce(new PVector(speed, 0));
      isMiningRight = true;
    }else{
      isMiningRight = false;
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
}
