void generateLayers(int layers) {  
  int mapDepth = map.size();

  for(int iY = mapDepth; iY <= mapDepth + layers; iY++) {
    ArrayList<Tile> subArray = new ArrayList<Tile>(); //make a list for the tiles
    map.add(subArray); // add the empty tile-list to the bigger list. We'll fill it a few lines down

    for(int iX = 0; iX <= tilesHorizontal; iX++) {
      Tile tile;
      if (iY > safeZone) { //temporary open air area
        tile = new Tile(iX, iY);
      } else {
        tile = new OpenTile(iX, iY);
      }
      
      subArray.add(tile); 
      tileList.add(tile);
    }
  }
}
