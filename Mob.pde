class Mob extends Movable {

  //Health
  float maxHealth = 30;
  float currentHealth = maxHealth;
  boolean isImmortal = false;  

  //Taking damage
  final float HURTCOOLDOWN = 60f;
  float timeSinceLastHurt = 0f; 
  boolean isHurt;

  //Mining
  int miningCooldown = 1; //cooldown in millis
  int lastMine;
  int baseDamage = 1;

  //Inventory
  ArrayList<Item> inventory = new ArrayList<Item>();
  int maxInventory = 2;
  int lastUse;
  int useCooldown = 100;

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

  public void attemptMine(BaseObject object){

    if(Globals.isInOverWorld){ // In the overworld we disable digging all together. 
      return; 
    }else{
      
      //ask the tile if they wanna be mined first
      if(!object.canMine()){
       return;
      }

      //simple cooldown check
      if(millis() < lastMine + miningCooldown){
       return;
      }
    
      if(hasHeldItem()){
        Held held = getHeldItem();

        if(!held.canMine(object, this)){
          return;
        }

        held.onMine(object, this);
      }
      else{
        object.takeDamage(getAttackPower(false)); //FIST MINING
      }

      lastMine = millis();
    }
  }

  public void takeDamage(float damageTaken){
    super.takeDamage(damageTaken);
    
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

  float getAttackPower(boolean useHeldItem){
    if(!useHeldItem || !hasHeldItem()){
      return baseDamage;
    }

    return baseDamage * getHeldItem().damageCoefficient;
  }
  
  void setMaxHp(float hpToSet){
    maxHealth = hpToSet;
    currentHealth = maxHealth;
  }

  boolean canPickUp(PickUp pickUp){
    return false;
  }

  boolean canAddToInventory(Item item){
    return inventory.size() < maxInventory;
  }

  void addToInventory(Item item){
    item.suspended = true;
    inventory.add(item);
  }

  void useInventory(){
    if(lastUse + useCooldown < millis()  && inventory.size() != 0){
      Item item = inventory.get(inventory.size() - 1);
      item.onUse(this);
      item.suspended = false;
      lastUse = millis();
    }
  }

  void removeFromInventory(Item item){
    inventory.remove(item);
  }
  boolean hasHeldItem(){
    for(Item item : inventory){
      if(item instanceof Held){
        return true;
      }
    }
    return false;
  }

  Held getHeldItem(){
    for(Item item : inventory){
      if(item instanceof Held){
        return (Held)item;
      }
    }
    return null; //should never happen, because we should always check hasHeldItem before calling this
  }
}