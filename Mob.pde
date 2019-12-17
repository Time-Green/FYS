class Mob extends Movable {

  //Health
  float maxHealth = 30;
  float currentHealth = maxHealth;
  boolean isImmortal = false;

  //Movement
  protected boolean isSwimming = false;
  protected boolean canSwim = false; 

  //Taking damage
  final float HURTCOOLDOWN = timeInSeconds(1);
  float timeSinceLastHurt = 0f; 
  boolean isHurt;

  //Mining
  float miningCooldown = timeInSeconds(.1f); //cooldown in millis
  float lastMine;
  float baseDamage = 1;

  //Inventory
  ArrayList<Item> inventory = new ArrayList<Item>();
  int selectedSlot = 1; //the selected slot. we'll always use this one if we can
  int maxInventory = 3;
  int lastUse;
  int useCooldown = 100;

  //regen and fire
  public float regen = 0.05f;
  private final float fireDamage = 6;
  public boolean canRegen = false;
  private boolean isOnFire = false;
  private int fireTimer;
  private int regenTimer;

  public void update() {
    super.update();

    handleOnFire();

    regenaration();

  if (canSwim) {
    if (isSwimming) {
      gravityForce = 0.1f;
    }
    else {
      gravityForce = 1;
    }
  }

    if (isHurt == true) {

      //Count up until we can be hurt again
      timeSinceLastHurt++;

      if (timeSinceLastHurt >= HURTCOOLDOWN) {
        timeSinceLastHurt = 0;
        isHurt = false;
      }
    }
  }

  public void attemptMine(BaseObject object) {

    // In the overworld we disable digging all together. 
    if (Globals.currentGameState == Globals.GameState.Overworld) {
      return;
    } else {

      //ask the tile if they wanna be mined first
      if (!object.canMine()) {
        return;
      }

      //simple cooldown check
      if (millis() < lastMine + miningCooldown) {
        return;
      }

      if (hasHeldItem()) {
        Held held = getHeldItem();

        if (!held.canMine(object, this)) {
          return;
        }

        held.onMine(object, this);
      } else {
        object.takeDamage(getAttackPower(false)); //FIST MINING
      }

      lastMine = millis();
      afterMine(object);
    }
  }

  void afterMine(BaseObject object){ //hook, used by player to count the mined tiles
    return;
  }

  public void takeDamage(float damageTaken) {
    super.takeDamage(damageTaken);

    if (isImmortal) {
      return;
    } else {

      if (isHurt == false) {
        isHurt = true;
        currentHealth -= damageTaken;
        regenTimer = 0;

        if (currentHealth <= 0) {
          die();
        }
      }
    }
  }

  public void die() {
  }

  float getAttackPower(boolean useHeldItem) {
    if (!useHeldItem || !hasHeldItem()) {
      return baseDamage;
    }

    return baseDamage * getHeldItem().damageCoefficient;
  }

    //fire damage blocks regenaration
  public void handleOnFire() {
    if(isOnFire){
      if(fireTimer % 30 == 0) {
        takeDamage(fireDamage);
        if(fireTimer > 180) {
          isOnFire = false;
        }
      }
      fireTimer++;
    }
  }

  void regenaration(){
    if(regenTimer > 120) {
      if(currentHealth < maxHealth){
        currentHealth += regen;
      }
    }
    regenTimer++;
  }

  void setOnFire() {
    isOnFire = true;
    fireTimer = 0;
  }

  void setMaxHp(float hpToSet) {
    maxHealth = hpToSet;
    currentHealth = maxHealth;
  }

  boolean canPickUp(PickUp pickUp) {
    return false;
  }

  boolean canAddToInventory(Item item) {
    if (inventory.contains(item)) {
      return false;
    }
    return inventory.size() < maxInventory;
  }

  void addToInventory(Item item) {
    rectMode(CENTER);
    item.suspended = true;
    inventory.add(item);
    rectMode(CORNER);
  }

  void useInventory() {
    if (lastUse + useCooldown < millis()  && inventory.size() != 0) {
      if (selectedSlot <= inventory.size()) {
        Item item = inventory.get(selectedSlot - 1);
        item.onUse(this);
        item.suspended = false;
        lastUse = millis();
      }
    }
  }

  void switchInventory() {
    selectedSlot++;
    if (selectedSlot > maxInventory) {
      selectedSlot = 1;
    }
  }

  void removeFromInventory(Item item) {
    inventory.remove(item);
  }
  boolean hasHeldItem() {
    for (Item item : inventory) {
      if (item instanceof Held) {
        return true;
      }
    }
    return false;
  }

  Held getHeldItem() {
    if (inventory.size() >= selectedSlot) {
      Item item = inventory.get(selectedSlot - 1);
      if (item instanceof Held) {
        return (Held) inventory.get(selectedSlot - 1);
      }
    }

    for (Item item : inventory) {
      if (item instanceof Held) {
        return (Held)item;
      }
    }
    return null; //should never happen, because we should always check hasHeldItem before calling this
  }

}
