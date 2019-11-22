class Biome{

    int length = 50; //after how many tiles do we tell world to get another biome?

    float caveSpawningNoiseScale = 0.1f;
    float caveSpawningPossibilityScale = 0.68f; //lower for more caves


 Tile getTileToGenerate(int x, int depth){

    float orechance = random(100);
    
    //spawn air at surface
    if(depth <= world.safeZone)
    {
      return new AirTile(x, depth);
    }
    else if(depth <= world.safeZone + 1) // 1 layer of grass (layer 11)
    {
      return new GrassTile(x, depth);
    }
    else if(depth < 15) //spawn 14 layers of dirt
    {
      return new DirtTile(x, depth);
    }
    else if(depth == 15) // 1 layer of dirt to stone transition
    {
      return new DirtStoneTransitionTile(x, depth);
    }
    else if(depth > 15 && depth <= 500){ //begin stone layers

      if(orechance > 80 && orechance <= 90)
      {
        return new CoalTile(x, depth);
      }
      else if(orechance > 90 && orechance <= 98)
      {
        return new IronTile(x, depth);
      }
      else if(orechance > 98 && orechance <= 100){
        //return new MysteryTile(x, depth);
        return new ExplosionTile(x, depth);
      }

    }
    else if(depth > 500){

      if(orechance > 80 && orechance <= 90)
      {
        return new GoldTile(x, depth);
      }
      else if(orechance > 90 && orechance <= 97)
      {
        return new DiamondTile(x, depth);
      }
      else if(orechance > 97 && orechance <= 100)
      {
        return new ObsedianTile(x, depth);
      }
      
    }
    
    //if no special tile was selected, spawn stone
    return new StoneTile(x, depth);
  }
}