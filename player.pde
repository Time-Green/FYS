class Player extends Mob {

  PVector spawnPosition = new PVector(1200, 500);
  int score = 0;

  public Player(){
    image = ResourceManager.getImage("player");
    position = spawnPosition;
  }

  void update(World world) {

    if (Globals.gamePaused) {  
      return;
    }
    
    super.update(world);

    doPlayerMovement();
  }
  
  void doPlayerMovement(){
    if(keys[UP] && isGrounded()){
      addForce(new PVector(0, -jumpForce));
    }

    if(keys[DOWN]){
      isMiningDown = true;
    }else{
      isMiningDown = false;
    }

    if(keys[LEFT]){
      addForce(new PVector(-speed, 0));
      isMiningLeft = true;
    }else{
      isMiningLeft = false;
    }

    if(keys[RIGHT]){
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
