void generateTiles(){
  
  for(int iY = 0; iY < tilesVertical; iY++){
    for(int iX = 0; iX < tilesHorizontal; iX++){
      if(iY > safeZone){
        tileList.add(new Tile(iX * tileWidth, iY * tileHeight));
      }
    }
  }
}
