public class Camera {

  private PVector position;
  private BaseObject target;
  private float lerpAmount;

  public Camera(BaseObject targetObject) {
    position = new PVector();

    setTarget(targetObject);
    
    setupInitialValues();
  }

  private void setupInitialValues(){
    position.x = -target.position.x + width * 0.5f - target.size.x / 2f;

    if(Globals.currentGameState == Globals.GameState.GameOver){
      position.y = -190;
    }else{
      position.y = 190;
    }
    
    lerpAmount = 0.002f;
  }

  public void setTarget(BaseObject targetObject) {
    target = targetObject;
  }

  public void update() {

    // if we dont have a target, do nothing
    if (target == null) {
      return;
    }

    //get current camera shake
    PVector currentCameraShakeOffset = CameraShaker.getShakeOffset();

    float targetX = -target.position.x + width * 0.5f - target.size.x / 2f;
    float targetY = -target.position.y + height * 0.5f - target.size.y / 2f;

    PVector targetPosition = new PVector(targetX, targetY);

    targetPosition.add(currentCameraShakeOffset);

    //position.set(targetPosition);
    position.lerp(targetPosition, lerpAmount);

    //limit x position so the camera doesent go to far to the left or right
    float minXposotion = -(Globals.TILES_HORIZONTAL * Globals.TILE_SIZE + Globals.TILE_SIZE - width);
    position.x = constrain(position.x, minXposotion, 0);

    translate(position.x, position.y);
  }

  public PVector getPosition() {
    return position;
  }
}
