class RelicShard extends PickUp {

  int type;

  RelicShard() {
    type = floor(random(5));
    if (type == 0) {
      //this is a mine boost
      image =  ResourceManager.getImage("RelicShard0");
    } else if (type == 1) {
      //this is a healthboost
      image =  ResourceManager.getImage("RelicShard1");
    }
    else if (type == 2) {
      //this is a regenboost
      image =  ResourceManager.getImage("RelicShard2");
    }
    else if (type == 3) {
      //this is a speedboost
      image =  ResourceManager.getImage("RelicShard3");
    }
    else if (type == 4) {
      //this is a speedboost
      image =  ResourceManager.getImage("RelicShard4");
    }
  }

  void pickedUp(Mob mob) {
    super.pickedUp(mob);
    //println("PICKUP " + type);
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
