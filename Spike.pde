class Spike extends Obstacle{

    Spike(){
        size.set(10, 50);
        image = ResourceManager.getImage("Spike");
        anchored = true;
    }

    void pushed(Mob mob, PVector otherPosition){

        if(otherPosition.y > 0){ //something fell on us, and we're a spike soooo
            mob.takeDamage(1f);
        }
    }
}