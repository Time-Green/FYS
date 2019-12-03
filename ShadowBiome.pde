 class ShadowBiome extends Biome{
 
    Tile getTileToGenerate(int x, int depth){
      float orechance = random(100);
      if(depth-startedAt<50 ){
        if(orechance <=4){
         return new ShadowGoldTile(x, depth);
        } else if(orechance <= 8){
          return new ShadowDiamondTile(x, depth);
        }else if(orechance <=16){
          return new ShadowSandTile(x, depth);
        }else if(orechance <=18){
          return new ObsedianTile(x, depth);
        }
      }

       return new ShadowTile(x, depth);
        
    }
 }