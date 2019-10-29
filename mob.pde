class Mob extends Atom {
  int maxHealth = 3;
  int currentHealth = maxHealth;
  int miningCooldown = 1; //cooldown in millis
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

  int getDamage(){ //obviously temporary till we get something like damage going
    return 1; 
  }
}
