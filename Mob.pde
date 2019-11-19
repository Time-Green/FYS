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
  int miningCooldown = 1; //cooldown in millis
  int lastMine;

  //Inventory
  ArrayList<Item> inventory = new ArrayList<Item>();
  int maxInventory = 2;
  int lastUse;
  int useCooldown = 100;

  public void attemptMine(BaseObject object){

    //ask the tile if they wanna be mined first
    if(!object.canMine()){
      return;
    }

    //simple cooldown check
    if(millis() < lastMine + miningCooldown){
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

  boolean canPickUp(PickUp pickUp){
    return false;
  }

  boolean canAddToInventory(Item item){
    return inventory.size() < maxInventory;
  }

  void addToInventory(Item item){
    item.position.set(0,0);
    inventory.add(item);
  }

  void useInventory(){
    if(lastUse + useCooldown < millis()  && inventory.size() != 0){
      Item item = inventory.get(inventory.size() - 1);
      item.onUse(this);
      lastUse = millis();
    }
  }

  void removeFromInventory(Item item){
    inventory.remove(item);
  }
}

