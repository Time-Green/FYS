class Mob extends Atom {
  int maxHealth = 3;
  int currentHealth = maxHealth;
  float hurtTimer = 1f;
  float savedTime;
  boolean isHurt;
  int miningCooldown = 100; //cooldown in millis
  int lastMine = 0; //before someone rolls by and removes the '= 0' in name of 'optimization', it's because of readability 

  void attemptMine(Tile tile){
    if(!tile.canMine()){ //ask the tile if they wanna be mined first
      return;
    }

    if(millis() < lastMine + miningCooldown){ //simple cooldown check
      return;
    }

    lastMine = millis();
    tile.takeDamage(getDamage());
  }

  void update(World world){
    super.update(world);

    if (isHurt == true){
      //float passedTime = second() - savedTime;

      // if (passedTime > hurtTimer) {
      if (frameCount % 60 == 0) {
        
        //savedTime = second();
        
        isHurt = false;
      }
    }
  }

  public void takeDamage(int amount){
    if(isHurt == false){
      isHurt = true;
      currentHealth -= amount;
      

      CameraShaker.induceStress(0.5f);
    }
  }

  int getDamage(){ //obviously temporary till we get something like damage going
    return 1; 
  }
}
