public class ExplosionTile extends Tile {

  private final float EXPLOSION_SIZE = 350;
  private final float DYNAMITE_EXPLOSION_SIZE = 200;
  private final float DIRECTIONAL_EXPLOSION_SIZE = 200;
  private boolean hasExploded = false;

  // 0: standard explosion
  // 1: dynamite
  // 2: directinal explosion, down
  // 3: directinal explosion, rotating
  int type;

  PImage[] directionalExplosions;
  int currentRotation;
  int randomStartRotation;

  boolean isDoingDynamiteExposion;
  boolean isDoingDirectionalExplosion;

  private final int MAX_EXPLOSIONS = 5;
  private final int MAX_EXPLOSION_DELAY = 3;
  private int currentExplosion = 0;
  private int currentExplosionDelay = MAX_EXPLOSION_DELAY;

  public ExplosionTile(int x, int y) {
    super(x, y);

    type = floor(random(4));

    if(type == 0){
      image = ResourceManager.getImage("BombTile");
    }else if(type == 1){
      image = ResourceManager.getImage("DynamiteTile");
    }else if(type == 2){
      image = ResourceManager.getImage("DirectinalExplosion0");
    }else if(type == 3){
      randomStartRotation = int(random(100));
      currentRotation = (randomStartRotation + frameCount) / 30 % 4;

      directionalExplosions = new PImage[4];

      for (int i = 0; i < directionalExplosions.length; i++) {
        directionalExplosions[i] = image = ResourceManager.getImage("DirectinalExplosion" + i);
      }

      image = directionalExplosions[currentRotation];
    }else{
      println("ERROR: type '" + type + "' not found");
    }
  }

  void mine(boolean playMineSound) {
    super.mine(playMineSound);

    explode();
  }

  void update(){

    super.update();

    if(Globals.currentGameState != Globals.GameState.InGame){
      return;
    }

    if(isDoingDynamiteExposion || isDoingDirectionalExplosion){

      if(currentExplosion < MAX_EXPLOSIONS){

        if(currentExplosionDelay >= MAX_EXPLOSION_DELAY){
          currentExplosionDelay = 0;
          currentExplosion++;

          if(isDoingDynamiteExposion){
            doDynamiteExplosion();
          }else{
            doDirectionalExplosion();
          }
        }
      }
      
      currentExplosionDelay++;
    }

    if (hasExploded) {
      return;
    }
    
    if(type == 3){
      currentRotation = (randomStartRotation + frameCount) / 30 % 4;

      image = directionalExplosions[currentRotation];
    }
  }

  private void doDynamiteExplosion(){
    load(new Explosion(new PVector(position.x + currentExplosion * Globals.TILE_SIZE, position.y), DYNAMITE_EXPLOSION_SIZE, 5, false));
    load(new Explosion(new PVector(position.x - currentExplosion * Globals.TILE_SIZE, position.y), DYNAMITE_EXPLOSION_SIZE, 5, false));
  }

  private void doDirectionalExplosion(){
    if(currentRotation == 0){ // down
      load(new Explosion(new PVector(position.x, position.y + currentExplosion * Globals.TILE_SIZE), DIRECTIONAL_EXPLOSION_SIZE, 5, false));
    }else if(currentRotation == 1){ // left
      load(new Explosion(new PVector(position.x - currentExplosion * Globals.TILE_SIZE, position.y), DIRECTIONAL_EXPLOSION_SIZE, 5, false));
    }else if(currentRotation == 2){ // up
      load(new Explosion(new PVector(position.x, position.y - currentExplosion * Globals.TILE_SIZE), DIRECTIONAL_EXPLOSION_SIZE, 5, false));
    }else if(currentRotation == 3){ // right
      load(new Explosion(new PVector(position.x + currentExplosion * Globals.TILE_SIZE, position.y), DIRECTIONAL_EXPLOSION_SIZE, 5, false));
    }
  }

  private void explode() {

    if (hasExploded) {
      return;
    }

    hasExploded = true;

    if(type == 0){
      regularExplosion();
    }else if(type == 1){
      dynamiteExplosion();
    }else if(type == 2 || type == 3){
      directionalExplosion();
    }else{
      println("ERROR: type '" + type + "' not found");
    }

  }

  private void regularExplosion(){
    load(new Explosion(position, EXPLOSION_SIZE, 5, false));
  }

  private void dynamiteExplosion(){
    isDoingDynamiteExposion = true;
  }

  private void directionalExplosion(){
    isDoingDirectionalExplosion = true;
  }
}
