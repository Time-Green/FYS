void generateTiles(){  
  for(int iY = 0; iY < tilesVertical; iY++){
    ArrayList<Tile> subArray = new ArrayList<Tile>(); //maak een lijst voor tile's
    map.add(subArray); //voeg de lege lijst voor tiles toe aan de grote lijst. we vullen hem een paar lijnen verder
    for(int iX = 0; iX < tilesHorizontal; iX++){
      Tile tile;
      if(iY > safeZone){ //tijdelijk voor een soort van open lucht gebied
        tile = new Tile(iX, iY);
      }
      else{
        tile = new openTile(iX, iY);
      }
      subArray.add(tile); 
      tileList.add(tile);
    }
  }
}
