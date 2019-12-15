class WallOfDeath extends Movable {

  private float minDistanceFromPlayer = 650f;
  private float maxDistanceFromPlayer = 1250f;
  private int currentDepthCheck = 0; 
  boolean isInBeginfase = true;
  private final int MAX_DEPTH_CHECK = 25; 

  private color wallColor = #FF8C33;

  private float gameStartSpawnMult = 0; 

  private float bufferZone; 

  private final int DESTROYTILESAFTER = 10; //destroys tiles permanently x tiles behind the WoD

  private final float BEGINFASE_OVERWORLD_HEIGHT = 750; 

  WallOfDeath() {

    float worldWidth = Globals.TILES_HORIZONTAL * Globals.TILE_SIZE + Globals.TILE_SIZE;

    size.set(worldWidth, Globals.TILE_SIZE * 2);
    position.y = player.position.y - maxDistanceFromPlayer;

    //for debug only, Remove this line of code when puplishing
    collisionEnabled = false;

    //movement is not done with gravity but only with velocity
    gravityForce = 0f;
    groundedDragFactor = 1f;
  }

  void update() {

    if (Globals.gamePaused || Globals.currentGameState == Globals.GameState.Overworld)
    {
      return;
    }

    super.update();

    if (gameStartSpawnMult < 1)
    {
      gameStartSpawnMult += 1f / 600f; // 10 second begin phase

      if (gameStartSpawnMult >= 1)
      {
        gameStartSpawnMult = 1; 
        isInBeginfase = false;
        ui.drawWarningOverlay = false;
      }
    }

    doStartingCameraShake();

    bufferZone = player.position.y - position.y; 
    //println(bufferZone); 

    //wod movement per frame
    position.y += bufferZone / 225;

    if (bufferZone < minDistanceFromPlayer) {
      //println("WOD TO LOW");
      position.y = player.position.y - minDistanceFromPlayer;
    } else if (bufferZone > maxDistanceFromPlayer) {
      //println("WOD TO HIGH");
      position.y = player.position.y - maxDistanceFromPlayer;
    }

    float maxAsteroidSpawnChange = 1 + ((bufferZone + player.position.y * 0.1f) * 0.000125f) * gameStartSpawnMult;

    //maxAsteroidSpawnChange *= gameStartSpawnMult; 

    //println("maxAsteroidSpawnChange: " + maxAsteroidSpawnChange);

    if (random(maxAsteroidSpawnChange) > 1)
    {     
      spawnAstroid();
    }

    cleanUpObjects();
  }

  void draw(){
    //don't draw anything
  }

  private void doStartingCameraShake() {

    if (Globals.currentGameState == Globals.GameState.InGame && isInBeginfase) {
      CameraShaker.induceStress(1f - gameStartSpawnMult * 1.5f);
    }
  }

  // If the WoD hits the player, the game is paused. 
  private void checkPlayerCollision() {

    if (CollisionHelper.rectRect(position, size, player.position, player.size)) {
      Globals.gamePaused = true;
      Globals.currentGameState = Globals.GameState.GameOver;
    }
  }

  void spawnAstroid() {

    if (isInBeginfase)
    {
      spawnRandomTargetedMeteor();
    } else {

      if (random(1f) < 0.2f) {
        spawnMeteorAbovePlayer();
      } else {
        //max depth we are going to scan
        int scanDepth = currentDepthCheck + MAX_DEPTH_CHECK;

        Tile spawnTarget = null;

        for (int i = currentDepthCheck; i < scanDepth; i++) {

          ArrayList<Tile> tileRow = world.getLayer(i);
          ArrayList<Tile> destructibleTilesInRow = new ArrayList<Tile>();

          for (Tile tile : tileRow) {

            if (tile.density) {
              destructibleTilesInRow.add(tile);
            }
          }

          if (destructibleTilesInRow.size() > 0) {

            spawnTarget = destructibleTilesInRow.get(int(random(destructibleTilesInRow.size())));
            break;
          } else {
            currentDepthCheck++;
          }
        }

        if (spawnTarget != null) {
          spawnTargetedMeteor(spawnTarget.position.x);
        }
      }
    }
  }

  private void spawnTargetedMeteor(float targetPosX) {

    float spawnPosX = targetPosX + random(-Globals.TILE_SIZE * 2, Globals.TILE_SIZE * 2);

    load(new Meteor(), new PVector(spawnPosX, position.y));
  }

  private void spawnMeteorAbovePlayer() {

    float spawnPosX = player.position.x + random(-Globals.TILE_SIZE * 2, Globals.TILE_SIZE * 2);

    load(new Meteor(), new PVector(spawnPosX, position.y));
  }

  private void spawnRandomTargetedMeteor() {

    float spawnX = random(Globals.TILES_HORIZONTAL * Globals.TILE_SIZE + Globals.TILE_SIZE); 

    while (abs(player.position.x - spawnX) < BEGINFASE_OVERWORLD_HEIGHT)
    {
      spawnX = random(Globals.TILES_HORIZONTAL * Globals.TILE_SIZE + Globals.TILE_SIZE);
    }

    load(new Meteor(), new PVector(spawnX, position.y));
  }

  private void cleanUpObjects() {

    for (BaseObject object : objectList) {

      //is the object above the wall of death..
      if (object.position.y < position.y - DESTROYTILESAFTER * Globals.TILE_SIZE) {

        //..and its not the player..
        if (object instanceof Player) {
          continue;
        }

        //..https://www.youtube.com/watch?v=Kbx7m2qVVA0
        delete(object);
      }
    }
  }
}
