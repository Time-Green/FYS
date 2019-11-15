class Mob extends Movable {

  //Health
  float maxHealth = 3;
  float currentHealth = maxHealth;
  boolean isImmortal = false;  

  //Taking damage
  final float HURTCOOLDOWN = 60f;
  float timeSinceLastHurt = 0f; 
  boolean isHurt;

  //Mining
  final int MININGCOOLDOWN = 100; //cooldown in millis
  int lastMine;

  public void attemptMine(BaseObject object){

    //ask the tile if they wanna be mined first
    if(!object.canMine()){
      return;
    }

    //simple cooldown check
    if(millis() < lastMine + MININGCOOLDOWN){
      return;
    }

    lastMine = millis();
    object.takeDamage(getAttackPower());
  }

  public void update(){
    super.update();

    if(isHurt == true){

      //Count up until we can be hurt again
      timeSinceLastHurt++;

      if(timeSinceLastHurt >= HURTCOOLDOWN){
        timeSinceLastHurt = 0;
        isHurt = false; 
      }
    }
  }

  public void takeDamage(float damageTaken){
  
    if(isImmortal){
      return; 
    }else{

      if(isHurt == false){
        isHurt = true;
        currentHealth -= damageTaken;

        if(currentHealth <= 0){
          die();
        }
      }
    }
  }

  public void die(){

  }

  int getAttackPower(){ //obviously temporary till we get something like damage going
    return 1; 
  }
  
  void setMaxHp(float hpToSet){
    maxHealth = hpToSet;
    currentHealth = maxHealth;
  }
}

