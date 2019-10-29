public class Camera{

    private PVector position;
    private Atom target;

    public Camera(Atom target){
        this.target = target;
        position = new PVector();

        update();
    }

    public void update(){
        //get current camera shake
        PVector currentCameraShakeOffset = CameraShaker.getShakeOffset();

        //do scrolling and add camera shake
        position.x = (-target.position.x + width * 0.5 - target.size.x / 2) + currentCameraShakeOffset.x;
        position.y = (-target.position.y + height * 0.5 - target.size.y / 2) + currentCameraShakeOffset.y;

        //limit x position so the camera doesent go to far to the left or right
        position.x = constrain(position.x, -1270, 0);

        translate(position.x, position.y);
    }

    public PVector getPosition(){
        return position;
    }

}
