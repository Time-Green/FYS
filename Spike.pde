class Spike extends Obstacle{

    Spike(){
        size = new PVector(10, 50);
        image = ResourceManager.getImage("Spike");
        anchored = true;
    }

    void pushed(Atom atom, float px, float py){
        println(px, py);
        if(py > 0){ //something fell on us, and we're a spike soooo
            atom.takeDamage(1);
        }
    }
}