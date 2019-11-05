class Mob extends Atom {

  //Health
  protected int maxHealth = 3;
  protected int currentHealth = maxHealth;

  //Taking damage
  protected final float HURTCOOLDOWN  = 60f;
  protected float timeSinceLastHurt = 0f; 
  protected boolean isHurt;

  //Mining
  protected final int MININGCOOLDOWN = 100; //cooldown in millis
  protected int lastMine = 0; //before someone rolls by and removes the '= 0' in name of 'optimization', it's because of readability 

  public void attemptMine(Tile tile){

    //ask the tile if they wanna be mined first
    if(!tile.canMine()){
      return;
    }

    //simple cooldown check
    if(millis() < lastMine + MININGCOOLDOWN){
      return;
    }

    lastMine = millis();
    tile.takeDamage(getAttackPower());
  }

  public void update(World world){
    super.update(world);

    if(this.isHurt == true){

      //Count up intul we can be hurt again
      this.timeSinceLastHurt ++;

      if(this.timeSinceLastHurt >= HURTCOOLDOWN){
        this.timeSinceLastHurt = 0;
        this.isHurt = false; 
      }
    }
  }

  public void takeDamage(int damageTaken){

    if(this.isHurt == false){

      this.isHurt = true;
      this.currentHealth -= damageTaken;

      if(this.currentHealth <= 0){
        die();
      }
    }
  }

  public void die(){

  }

  int getAttackPower(){ //obviously temporary till we get something like damage going
    return 1; 
  }

}
