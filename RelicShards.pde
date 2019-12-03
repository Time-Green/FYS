class RelicShard extends PickUp {

  int healthBoost = 20;
  int damageBoost = 20;
  float relicChance = 100f;
  int amountRequired = 3;
  int currentShard0 = 0;
  int currentShard1 = 0;
  int type;

  RelicShard() {
    type = int(random(2));
    println(type);
    if (type == 0) {
      //this is a mine boost
      image =  ResourceManager.getImage("RelicShard0");
    } else if (type == 1) {
      //this is a healthboost
      image =  ResourceManager.getImage("RelicShard1");
    }
  }

  // void apply() {
  //   if (currentShard0 == amountRequired) {
  //     Player.maxHealth += healthBoost;
  //   }
  //     if (currentShard1 == amountRequired) {
  //      Player.baseDamage += damageBoost;
  //   }
  // }


}
