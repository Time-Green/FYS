class Mob extends Atom {
  //Health
  int maxHealth = 3;
  int currentHealth = maxHealth;

  //Taking damage
  final float HURTCOOLDOWN  = 60f;
  float timeSinceLastHurt = 0f; 
  boolean isHurt;

  //Mining
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
    tile.takeDamage(getAttackPower());
  }

  void update(World world){
    super.update(world);

    if (this.isHurt == true) {

      //Count up intul we can be hurt again
      this.timeSinceLastHurt ++;

      if (this.timeSinceLastHurt >= HURTCOOLDOWN) {
        this.timeSinceLastHurt = 0;
        this.isHurt = false; 
      }

    }
  }

  public void takeDamage(int amount) {
    if(this.isHurt == false){
      this.isHurt = true;
      this.currentHealth -= amount;
      CameraShaker.induceStress(0.5f);
    }
  }

  int getAttackPower(){ //obviously temporary till we get something like damage going
    return 1; 
  }
}
