public class Camera {

  private PVector position;
  private BaseObject target;

  public Camera(BaseObject targetObject) {
    position = new PVector();

    setTarget(targetObject);
    update();
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

    float targetX = -target.position.x + width * 0.5 - target.size.x / 2;
    float targetY = -target.position.y + height * 0.5 - target.size.y / 2;

    PVector targetPosition = new PVector(targetX, targetY);

    targetPosition.add(currentCameraShakeOffset);

    //position.set(targetPosition);
    position.lerp(targetPosition, 0.1f);

    //limit x position so the camera doesent go to far to the left or right
    float minXposotion = -(tilesHorizontal * tileSize + tileSize - width);
    position.x = constrain(position.x, minXposotion, 0);

    translate(position.x, position.y);
  }

  public PVector getPosition() {
    return position;
  }
}
