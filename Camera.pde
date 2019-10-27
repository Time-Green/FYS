public class Camera{

    private PVector position;
    private Atom target;

    public Camera(Atom target){
        this.target = target;
        position = new PVector();

        update();
    }

    public void update(){
        position.x = constrain(-target.position.x + width * 0.5 - target.size.x / 2, -1270, 0);
        position.y = -target.position.y + height * 0.5 - target.size.y / 2;

        translate(position.x, position.y);
    }

    public PVector getPosition(){
        return position;
    }

}
