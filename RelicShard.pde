class RelicShard extends PickUp {

  int type;

  RelicShard() {
    type = int(random(2));
    //println(type);
    if (type == 0) {
      //this is a mine boost
      image =  ResourceManager.getImage("RelicShard0");
    } else if (type == 1) {
      //this is a healthboost
      image =  ResourceManager.getImage("RelicShard1");
    }
  }

  void pickedUp(Mob mob) {
    super.pickedUp(mob);
    PlayerRelicInventory playerRelicInventory = getRelicShardInventoryByType();
    if(playerRelicInventory == null) {
      PlayerRelicInventory newPlayerRelicInventory = new PlayerRelicInventory();
      newPlayerRelicInventory.relicshardid = type;
      newPlayerRelicInventory.amount = 1;

      totalCollectedRelicShards.add(newPlayerRelicInventory);
    }
    else{
      playerRelicInventory.amount++;
    }

    runData.collectedRelicShards.add(this);
  }

  PlayerRelicInventory getRelicShardInventoryByType(){
    for(PlayerRelicInventory collectedRelicShardInventory : totalCollectedRelicShards) {
      if(collectedRelicShardInventory.relicshardid == type) {
        return collectedRelicShardInventory;
      }
    }
    return null;
  }
}
