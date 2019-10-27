public class Camera{

    private PVector position;
    private Atom target;

    public Camera(Atom target){
        this.target = target;
        position = new PVector();

        update();
    }

    public void update(){
        position.x = -target.position.x + width * 0.5 - target.size.x / 2;
        position.y = -target.position.y + height * 0.5 - target.size.y / 2;

        translate(constrain(position.x, -1270, 0), position.y);
    }

    public PVector getPosition(){
        return position;
    }

}
