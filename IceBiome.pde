 class IceBiome extends Biome{

    IceBiome(){

     destroyedImage = ResourceManager.getImage("DestroyedIce");

   }

    Tile getTileToGenerate(int x, int depth){
      float orechance = random(100);
      caveSpawningPossibilityScale = .60;
      enemyChance = 0.03;

      if(depth-startedAt<50 ){
        if(orechance <=4){
         return new GreenIceTile(x, depth);
        } else if(orechance <= 8){
          return new RedIceTile(x, depth);
        }else if(orechance <=12){
          return new IceTile2(x, depth);
        }
      }

       return new IceTile(x, depth);
        
    }
 }