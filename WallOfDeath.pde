class WallOfDeath extends Movable {

  //private float moveSpeed = 1f;
  private float wallYOffset = 600;
  private int currentDepthCheck = 0; 

  private final int MAX_DEPTH_CHECK = 25; 

  private color wallColor = #FF8C33;

  private final int DESTROYTILESAFTER = 10; //destroys tiles permanently x tiles behind the WoD

  WallOfDeath(float wallWidth){

    //velocity.set(0, moveSpeed);
    size.set(wallWidth, tileHeight * 2);
    position.set(0, -size.y - wallYOffset);

    //for debug only, Remove this line of code when puplishing
    collisionEnabled = false;

    //movement is not done with gravity but only with velocity
    gravityForce = 0f;
    groundedDragFactor = 1f;
  }
  
  void update(){

    if (Globals.gamePaused){
      return;
    }

  if(frameCount % 5 == 0){ 
    spawnAstroid();  
  }

  super.update();

    //velocity.y = player.getDepth() / 1000; // velocity of the WoD increases as the player digs deeper (temporary)
    position.y = currentDepthCheck * tileHeight - size.y - wallYOffset;
    
    cleanUpObjects();
  }

  void draw(){
    fill(wallColor);
    rect(position.x, position.y, size.x, size.y);
    fill(255);
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

      if(random(4) < 2){
        spawnTargetedMeteor(spawnTarget.position.x);
      }else{
        spawnRandomTargetedMeteor();
      }

    }else{
      spawnRandomTargetedMeteor();
    }
  }

  private void spawnTargetedMeteor(float targetPosX){

    float spawnPosX = targetPosX + random(-tileWidth * 2, tileWidth * 2);

    load(new Meteor(), new PVector(spawnPosX, position.y)); 
  }

  private void spawnRandomTargetedMeteor(){
    load(new Meteor(), new PVector(random(tilesHorizontal * tileWidth + tileWidth), position.y)); 
  }

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
