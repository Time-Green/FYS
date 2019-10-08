void generateTiles(){  

  for(int iY = 0; iY <= tilesVertical; iY++){

    ArrayList<Tile> subArray = new ArrayList<Tile>(); //make a list for the tiles
    map.add(subArray); // add the empty tile-list to the bigger list. We'll fill it a few lines further
    for(int iX = 0; iX <= tilesHorizontal; iX++){

      Tile tile;

      if(iY > safeZone){ //temporary open air area
        tile = new Tile(iX, iY);
      }
      else{
        tile = new OpenTile(iX, iY);
      }
      
      subArray.add(tile); 
      tileList.add(tile);
    }
  }
}
