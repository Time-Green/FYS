class WallOfDeath extends Movable {

  private float minDistanceFromPlayer = 650f;
  private float maxDistanceFromPlayer = 1250f;
  private int currentDepthCheck = 0; 

  private final int MAX_DEPTH_CHECK = 25; 

  private color wallColor = #FF8C33;

  private float bufferZone; 

  private final int DESTROYTILESAFTER = 10; //destroys tiles permanently x tiles behind the WoD

  WallOfDeath(float wallWidth){

    size.set(wallWidth, tileHeight * 2);
    position.y = player.position.y - maxDistanceFromPlayer;

    //for debug only, Remove this line of code when puplishing
    collisionEnabled = false;

    //movement is not done with gravity but only with velocity
    gravityForce = 0f;
    groundedDragFactor = 1f;
  }
  
  void update(){

    if (Globals.gamePaused || Globals.isInOverWorld)
    {
      return;
    }

    super.update();

    if(!Globals.isInOverWorld && player != null)
    {
      bufferZone = player.position.y - position.y; 
      //println(bufferZone); 

      //wod movement per frame
      position.y += bufferZone / 225;

      if(bufferZone < minDistanceFromPlayer){
        //println("WOD TO LOW");
        position.y = player.position.y - minDistanceFromPlayer;
      }else if(bufferZone > maxDistanceFromPlayer){
        //println("WOD TO HIGH");
        position.y = player.position.y - maxDistanceFromPlayer;
      }

      float maxAsteroidSpawnChange = 1 + (bufferZone + player.position.y * 0.1f) * 0.0001f;

      //println("maxAsteroidSpawnChange: " + maxAsteroidSpawnChange);

      if(random(maxAsteroidSpawnChange) > 1)
      {       
        spawnAstroid();  
      }
      
      cleanUpObjects();
    }
  }

  // If the WoD hits the player, the game is paused. 
  private void checkPlayerCollision(){

    if (CollisionHelper.rectRect(position, size, player.position, player.size)){
      Globals.gamePaused = true;
      Globals.currentGameState = Globals.GameState.GameOver;
    }

  }

  void spawnAstroid(){

    //max depth we are going to scan
    int scanDepth = currentDepthCheck + MAX_DEPTH_CHECK;
    
    Tile spawnTarget = null;
    
    for(int i = currentDepthCheck; i < scanDepth; i++){

      ArrayList<Tile> tileRow = world.getLayer(i);
      ArrayList<Tile> destructibleTilesInRow = new ArrayList<Tile>();

      for(Tile tile : tileRow){

        if(tile.density){
          destructibleTilesInRow.add(tile);
        }
      }

      if(destructibleTilesInRow.size() > 0){
        
        spawnTarget = destructibleTilesInRow.get(int(random(destructibleTilesInRow.size())));
        break;

      }else{
        currentDepthCheck++;
      }
    }

    if(spawnTarget != null){
      spawnTargetedMeteor(spawnTarget.position.x);
    }
  }

  private void spawnTargetedMeteor(float targetPosX){

    float spawnPosX = targetPosX + random(-tileWidth * 2, tileWidth * 2);

    load(new Meteor(), new PVector(spawnPosX, position.y)); 
  }

  // private void spawnRandomTargetedMeteor(){
  //   load(new Meteor(), new PVector(random(tilesHorizontal * tileWidth + tileWidth), position.y)); 
  // }

  private void cleanUpObjects(){

    for (BaseObject object : objectList) {
      
      //is the object above the wall of death..
      if(object.position.y < position.y - DESTROYTILESAFTER * tileHeight){

        //..and its not the player..
        if(object instanceof Player){
          continue;
        }

        //..https://www.youtube.com/watch?v=Kbx7m2qVVA0
        delete(object);
      }
    }
  }
}
