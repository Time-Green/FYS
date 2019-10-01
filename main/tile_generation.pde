void generateTiles(){
  
  for(int iY = 0; iY < tilesVertical; iY++){
    for(int iX = 0; iX < tilesHorizontal; iX++){
      Tile tile;
      if(iY > safeZone){
        tile = new Tile(iX * tileWidth, iY * tileHeight);
      }
      else{
        tile = new openTile(iX * tileWidth, iY * tileHeight);
      }
      tileList.add(tile);
      map.put(str(iX) + str(iY), tile);
    }
  }
}
